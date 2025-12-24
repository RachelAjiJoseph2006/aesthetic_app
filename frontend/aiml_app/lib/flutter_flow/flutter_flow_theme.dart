// lib/flutter_flow/flutter_flow_theme.dart
import 'package:flutter/material.dart';

class FlutterFlowTheme {
  final BuildContext context;
  FlutterFlowTheme.of(this.context);

  static _TextStyles of(BuildContext context) => _TextStyles();

  // Use this to keep API compatible with FlutterFlow generated code
}

class _TextStyles {
  TextStyle get titleSmall => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  TextStyle get headlineMedium => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      );
}
