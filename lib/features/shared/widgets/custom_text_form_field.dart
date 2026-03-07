import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String text;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon, suffixIcon;
  final String? Function(String?)? validatorFunction;

  const CustomTextFormField({
    super.key,
    required this.textEditingController,
    required this.text,
    this.obscureText,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    required this.validatorFunction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
        labelText: text,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      validator: validatorFunction,
    );
  }
}
