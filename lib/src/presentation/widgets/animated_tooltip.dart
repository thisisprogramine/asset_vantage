import 'dart:ui';

import 'package:asset_vantage/src/config/constants/size_constants.dart';
import 'package:asset_vantage/src/config/extensions/size_extensions.dart';
import 'package:asset_vantage/src/presentation/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class TooltipArrowPainter extends CustomPainter {
  final Color color;
  final bool isInverted;

  TooltipArrowPainter({
    required this.color,
    required this.isInverted,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    if (isInverted) {
      path.moveTo(0.0, size.height);
      path.lineTo(size.width / 2, 0.0);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0.0, 0.0);
      path.lineTo(size.width / 2, size.height);
      path.lineTo(size.width, 0.0);
    }

    path.close();

    canvas.drawShadow(path, Colors.black, 4.0, false);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TooltipArrow extends StatelessWidget {
  final Size size;
  final Color color;
  final bool isInverted;

  const TooltipArrow({
    super.key,
    this.size = const Size(16.0, 16.0),
    this.color = Colors.white,
    this.isInverted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(-size.width / 2, 0.0),
      child: CustomPaint(
        size: size,
        painter: TooltipArrowPainter(
          color: color,
          isInverted: isInverted,
        ),
      ),
    );
  }
}
class AnimatedTooltip extends StatefulWidget {
  final Widget content;
  final GlobalKey? targetGlobalKey;
  final Duration? delay;
  final ThemeData? theme;
  final Widget? child;

  const AnimatedTooltip({
    super.key,
    required this.content,
    this.targetGlobalKey,
    this.theme,
    this.delay,
    this.child,
  }) : assert(child != null || targetGlobalKey != null);

  @override
  State<StatefulWidget> createState() => AnimatedTooltipState();
}

OverlayEntry? _overlayEntry;
Timer? _dismissTimer;

class AnimatedTooltipState extends State<AnimatedTooltip>
    with SingleTickerProviderStateMixin {
  late double? _tooltipTop;
  late double? _tooltipBottom;
  late Alignment _tooltipAlignment;
  late Alignment _transitionAlignment;
  late Alignment _arrowAlignment;
  bool _isInverted = false;
  Timer? _delayTimer;

  final _arrowSize = const Size(16.0, 16.0);
  final _tooltipMinimumHeight = 140;

  late final AnimationController _animationController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );
  late final Animation<double> _scaleAnimation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeOutBack,
  );

  void _toggle() {
    _delayTimer?.cancel();
    _animationController.stop();
    if (_overlayEntry != null) {
      _animationController.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    } else {
      _updatePosition();
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context)?.insert(_overlayEntry!);
      _animationController.forward();
      if (widget.delay != null) {
        _dismissTimer?.cancel();
        addDismissDelay(widget.delay!);
      }
    }
  }
  void addDismissDelay(Duration delay) {
    _dismissTimer = Timer(delay, () {
      _animationController.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    });
  }

  void _updatePosition() {
    final Size contextSize = MediaQuery.of(context).size;
    final BuildContext? targetContext = widget.targetGlobalKey != null
        ? widget.targetGlobalKey!.currentContext
        : context;
    final targetRenderBox = targetContext?.findRenderObject() as RenderBox;
    final targetOffset = targetRenderBox.localToGlobal(Offset.zero);
    final targetSize = targetRenderBox.size;
    final tooltipFitsAboveTarget = targetOffset.dy - _tooltipMinimumHeight >= 0;
    final tooltipFitsBelowTarget =
        targetOffset.dy + targetSize.height + _tooltipMinimumHeight <=
            contextSize.height;
    _tooltipTop = tooltipFitsAboveTarget
        ? null
        : tooltipFitsBelowTarget
        ? targetOffset.dy + targetSize.height
        : null;
    _tooltipBottom = tooltipFitsAboveTarget
        ? contextSize.height - targetOffset.dy
        : tooltipFitsBelowTarget
        ? null
        : targetOffset.dy + targetSize.height / 2;
    _isInverted = _tooltipTop != null;
    _tooltipAlignment = Alignment(
      (targetOffset.dx) / (contextSize.width - targetSize.width) * 2 - 1.0,
      _isInverted ? 1.0 : -1.0,
    );
    _transitionAlignment = Alignment(
      (targetOffset.dx + targetSize.width / 2) / contextSize.width * 2 - 1.0,
      _isInverted ? -1.0 : 1.0,
    );
    _arrowAlignment = Alignment(
      (targetOffset.dx + targetSize.width / 2) /
          (contextSize.width - _arrowSize.width) *
          2 -
          1.0,
      _isInverted ? 1.0 : -1.0,
    );
  }

  OverlayEntry _createOverlayEntry() {
    final theme = widget.theme ??
        ThemeData(
          useMaterial3: true,
          brightness: Theme.of(context).brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
        );

    return OverlayEntry(
      builder: (context) => Positioned(
        top: _tooltipTop,
        bottom: _tooltipBottom,
        left: ScreenUtil().screenWidth * 0.3,
        right: Sizes.dimen_12,
        child: Container(
          child: ScaleTransition(
            alignment: _transitionAlignment,
            scale: _scaleAnimation,
            child: GestureDetector(
              onTap: _toggle,
              child: Theme(
                data: theme,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isInverted)
                      Align(
                        alignment: _arrowAlignment,
                        child: TooltipArrow(
                          size: _arrowSize,
                          isInverted: true,
                          color: theme.canvasColor,
                        ),
                      ),
                    Align(
                      alignment: _tooltipAlignment,
                      child: IntrinsicWidth(
                        child: Material(
                          elevation: 4.0,
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(8.0),
                          child: ClipRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColor.white,
                                  borderRadius: BorderRadius.circular(5.0)
                                ),
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    widget.content,
                                    SizedBox(height: Sizes.dimen_2.h),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton(
                                        onPressed: _toggle,
                                        child: Text('Got it!', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColor.white),),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (!_isInverted)
                      Align(
                        alignment: _arrowAlignment,
                        child: TooltipArrow(
                          size: _arrowSize,
                          isInverted: false,
                          color: AppColor.grey.withOpacity(0.5),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.delay != null) {
        _delayTimer = Timer(widget.delay!, _toggle);
      }
    });
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _animationController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child != null
        ? GestureDetector(
      onTap: _toggle,
      child: widget.child,
    )
        : const SizedBox.shrink();
  }
}
