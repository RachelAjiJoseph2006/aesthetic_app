// lib/flutter_flow/flutter_flow_widgets.dart
import 'package:flutter/material.dart';

class FFButtonOptions {
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry iconPadding;
  final Color color;
  final TextStyle textStyle;
  final double elevation;
  final BorderSide borderSide;
  final BorderRadius borderRadius;

  FFButtonOptions({
    this.width = 200,
    this.height = 40,
    this.padding = const EdgeInsets.all(8),
    this.iconPadding = EdgeInsets.zero,
    this.color = Colors.blue,
    this.textStyle = const TextStyle(color: Colors.white),
    this.elevation = 2.0,
    this.borderSide = const BorderSide(color: Colors.transparent),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });
}

class FFButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final FFButtonOptions options;

  const FFButtonWidget({
    Key? key,
    required this.onPressed,
    required this.text,
    this.options = const FFButtonOptions(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: options.width,
      height: options.height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: options.color,
          elevation: options.elevation,
          padding: options.padding,
          shape: RoundedRectangleBorder(
            borderRadius: options.borderRadius,
            side: options.borderSide,
          ),
        ),
        child: Text(text, style: options.textStyle),
      ),
    );
  }
}
