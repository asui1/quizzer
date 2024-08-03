import 'package:flutter/material.dart';
import 'package:quizzer/Functions/Logger.dart';

class CustomNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> _stack = [];

  bool isPageInStack(String pageName) {
    printStack();
    return _stack.any((route) => route.settings.name == pageName);
  }

  void printStack() {
    print('Current stack:');
    for (var route in _stack) {
      Logger.log(route.settings.name);
    }
  }


  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.add(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.remove(route);
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.remove(route);
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null) {
      _stack.remove(oldRoute);
    }
    if (newRoute != null) {
      _stack.add(newRoute);
    }
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}