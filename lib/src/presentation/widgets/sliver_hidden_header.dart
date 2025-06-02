import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class SliverHidedHeader extends SingleChildRenderObjectWidget {
  const SliverHidedHeader({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSliverHidedHeader(context: context);
  }
}

class RenderSliverHidedHeader extends RenderSliverSingleBoxAdapter {
  RenderSliverHidedHeader({
    required BuildContext context,
    RenderBox? child,
  })  : _context = context,
        super(child: child);
  bool _correctScrollOffsetNextLayout = true;
  bool _showChild = true;
  BuildContext _context;

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    final SliverConstraints constraints = this.constraints;
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    final double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child!.size.width;
        break;
      case Axis.vertical:
        childExtent = child!.size.height;
        break;
    }
    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final double cacheExtent =
        calculateCacheOffset(constraints, from: 0.0, to: childExtent);

    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);
    if (_correctScrollOffsetNextLayout) {
      geometry = SliverGeometry(scrollOffsetCorrection: childExtent);
      _correctScrollOffsetNextLayout = false;
      return;
    }
    _manageSnapEffect(
      childExtent: childExtent,
      paintedChildSize: paintedChildSize,
    );
    _manageInsertChild(
      childExtent: childExtent,
      paintedChildSize: paintedChildSize,
    );

    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      paintOrigin: _showChild ? 0 : -paintedChildSize,
      layoutExtent: _showChild ? null : 0,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
    );
    setChildParentData(child!, constraints, geometry!);
  }
  @override
  void dispose() {
    if (_context.mounted) {
      final _scrollPosition = Scrollable.of(_context).position;
      if (_subscribedSnapScrollNotifierListener != null) {
        _scrollPosition.isScrollingNotifier
            .removeListener(_subscribedSnapScrollNotifierListener!);
      }
      if (_subscribedInsertChildScrollNotifierListener != null) {
        _scrollPosition.isScrollingNotifier
            .removeListener(_subscribedInsertChildScrollNotifierListener!);
      }
    }

    super.dispose();
  }
  void Function()? _subscribedSnapScrollNotifierListener;
  _manageSnapEffect({
    required double childExtent,
    required double paintedChildSize,
  }) {
    final _scrollPosition = Scrollable.of(_context).position;
    if (_subscribedSnapScrollNotifierListener != null) {
      _scrollPosition.isScrollingNotifier
          .removeListener(_subscribedSnapScrollNotifierListener!);
    }
    _subscribedSnapScrollNotifierListener = () => _snapScrollNotifierListener(
          childExtent: childExtent,
          paintedChildSize: paintedChildSize,
        );
    _scrollPosition.isScrollingNotifier
        .addListener(_subscribedSnapScrollNotifierListener!);
  }
  void _snapScrollNotifierListener({
    required double childExtent,
    required double paintedChildSize,
  }) {
    final _scrollPosition = Scrollable.of(_context).position;
    final isIdle = _scrollPosition.activity is IdleScrollActivity;
    final isChildVisible = paintedChildSize > 0;

    if (isIdle && isChildVisible) {
      if (paintedChildSize >= childExtent / 2 &&
          paintedChildSize != childExtent) {
        _scrollPosition.animateTo(
          0,
          duration: Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
      else if (paintedChildSize < childExtent / 2 && paintedChildSize != 0) {
        HapticFeedback.lightImpact();
        SystemSound.play(SystemSoundType.click);
        _scrollPosition.animateTo(
          childExtent,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    }
  }
  void Function()? _subscribedInsertChildScrollNotifierListener;
  void _manageInsertChild({
    required double childExtent,
    required double paintedChildSize,
  }) {
    final _scrollPosition = Scrollable.of(_context).position;
    if (_subscribedInsertChildScrollNotifierListener != null) {
      _scrollPosition.isScrollingNotifier
          .removeListener(_subscribedInsertChildScrollNotifierListener!);
    }
    _subscribedInsertChildScrollNotifierListener =
        () => _insertChildScrollNotifierListener(
              childExtent: childExtent,
              paintedChildSize: paintedChildSize,
            );
    _scrollPosition.isScrollingNotifier
        .addListener(_subscribedInsertChildScrollNotifierListener!);
  }
  void _insertChildScrollNotifierListener({
    required double childExtent,
    required double paintedChildSize,
  }) {
    final _scrollPosition = Scrollable.of(_context).position;

    final isScrolling = _scrollPosition.isScrollingNotifier.value;
    if (isScrolling) {
      return;
    }

    final scrollOffset = _scrollPosition.pixels;
    if (!_showChild && scrollOffset <= 0.1) {
      _showChild = true;
      _correctScrollOffsetNextLayout = true;
      HapticFeedback.lightImpact();
      SystemSound.play(SystemSoundType.click);
      markNeedsLayout();
    }
    if (_scrollPosition.physics
        .containsScrollPhysicsOfType<ClampingScrollPhysics>()) {
      if (!_showChild && scrollOffset == childExtent) {
        _showChild = true;
        HapticFeedback.lightImpact();
        SystemSound.play(SystemSoundType.click);
        markNeedsLayout();
      }
    }
    if (_showChild && scrollOffset > childExtent) {
      _showChild = false;
      markNeedsLayout();
    }
  }
}
extension _ScrollPhysicsExtension on ScrollPhysics {
  bool containsScrollPhysicsOfType<T extends ScrollPhysics>() {
    return this is T || (parent?.containsScrollPhysicsOfType<T>() ?? false);
  }
}
