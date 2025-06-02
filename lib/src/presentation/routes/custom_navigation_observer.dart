
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:newrelic_mobile/newrelic_mobile.dart';

class CustomNavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    log("Current Route: ${route.settings.name ?? 'Unknown'}");
    NewrelicMobile.instance.recordBreadcrumb(
      'Route Pushed',
      eventAttributes: {'route': route.settings.name ?? 'Unknown'},
    );
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    log("Current Route: ${route.settings.name ?? 'Unknown'}");
    NewrelicMobile.instance.recordBreadcrumb(
      'Route Popped',
      eventAttributes: {'route': route.settings.name ?? 'Unknown'},
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    log("Current Route: ${route.settings.name ?? 'Unknown'}");
    NewrelicMobile.instance.recordBreadcrumb(
      'Route Removed',
      eventAttributes: {'route': route.settings.name ?? 'Unknown'},
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    log("Current Route: ${newRoute?.settings.name ?? 'Unknown'}");
    NewrelicMobile.instance.recordBreadcrumb(
      'Route Replaced',
      eventAttributes: {'route': newRoute?.settings.name ?? 'Unknown'},
    );
  }
}
