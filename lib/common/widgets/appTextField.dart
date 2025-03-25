import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Apptextfield extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final TextInputType keyboardType;
  final double borderRadius;
  final BorderSide borderSide;
  final Widget? leadingIcon;
  final VoidCallback? leadingIconOnTap;
  final double? width;
  final double? height;
  final String? errorText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool obscureText;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign textAlign;
  final int? maxLines;
  final int? minLines;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;

  const Apptextfield({
    super.key,
    this.labelText,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.borderRadius = 8.0,
    this.borderSide = const BorderSide(width: 1.0, color: Colors.grey),
    this.leadingIcon,
    this.leadingIconOnTap,
    this.width,
    this.height,
    this.errorText,
    this.validator,
    this.controller,
    this.obscureText = false,
    this.focusNode,
    this.onChanged,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.minLines,
    this.style,
    this.labelStyle,
    this.hintStyle,
    this.errorStyle,
    this.contentPadding,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
  });

  @override
  _ApptextfieldState createState() => _ApptextfieldState();
}

class _ApptextfieldState extends State<Apptextfield> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        focusNode: widget.focusNode,
        onChanged: widget.onChanged,
        inputFormatters: widget.inputFormatters,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        style: widget.style,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: widget.labelStyle,
          hintText: widget.hintText,
          hintStyle: widget.hintStyle,
          errorText: widget.errorText,
          errorStyle: widget.errorStyle,
          contentPadding: widget.contentPadding,
          prefixIcon: widget.leadingIcon != null
              ? InkWell(
                  onTap: widget.leadingIconOnTap,
                  child: widget.leadingIcon,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: widget.borderSide,
          ),
          focusedBorder: widget.focusedBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: widget.borderSide,
              ),
          errorBorder: widget.errorBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: widget.borderSide,
              ),
          focusedErrorBorder: widget.focusedErrorBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: widget.borderSide,
              ),
        ),
        validator: widget.validator,
      ),
    );
  }
}
