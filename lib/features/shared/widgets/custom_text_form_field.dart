import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final bool? obscureText;
  final int? maxLines;
  final TextInputType? keyboardType;
  final Widget? prefixIcon, suffixIcon;
  final String? Function(String?)? validatorFunction;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.text,
    this.obscureText,
    this.maxLines,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.validatorFunction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines ?? 1,
      controller: controller,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: text,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      validator: validatorFunction,
    );
  }
}
