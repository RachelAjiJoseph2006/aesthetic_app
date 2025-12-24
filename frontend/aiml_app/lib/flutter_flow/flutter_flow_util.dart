// lib/flutter_flow/flutter_flow_util.dart
import 'package:flutter/material.dart';

T createModel<T>(BuildContext context, T Function() creator) {
  // simple model factory - just return new instance
  return creator();
}

void safeSetState(State state, VoidCallback fn) {
  if (state.mounted) {
    state.setState(fn);
  }
}

bool responsiveVisibility({
  required BuildContext context,
  bool desktop = true,
  bool tablet = true,
  bool phone = true,
}) {
  // simple: return true on all devices unless explicitly checking desktop
  final width = MediaQuery.of(context).size.width;
  if (desktop == false && width > 900) return false;
  return true;
}

extension FFNavigator on BuildContext {
  Future<T?> pushNamed<T extends Object?>(String routeName, {Object? arguments}) {
    return Navigator.pushNamed<T>(this, routeName, arguments: arguments);
  }
}
