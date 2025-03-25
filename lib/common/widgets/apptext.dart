import 'package:flutter/material.dart';

class AppTextstyle extends StatelessWidget {
  const AppTextstyle({
    super.key,
    required this.text,
    required this.style,
    this.maxLines,
    this.softWrap = false,
    this.textAlign = TextAlign.left,
    this.overflow = TextOverflow.ellipsis,
    this.textDirection,
    this.locale,
    this.strutStyle,
    this.semanticsLabel,
  });

  final String text;
  final TextStyle style;
  final int? maxLines;
  final bool softWrap;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final TextDirection? textDirection;
  final Locale? locale;
  final StrutStyle? strutStyle;

  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      softWrap: softWrap,
      textAlign: textAlign,
      overflow: overflow,
      style: style,
      textDirection: textDirection,
      locale: locale,
      strutStyle: strutStyle,
      semanticsLabel: semanticsLabel,
    );
  }
}
