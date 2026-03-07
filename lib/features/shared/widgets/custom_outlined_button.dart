import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final double? height;
  final void Function()? onPressed;
  final String text;

  const CustomOutlinedButton({
    super.key,
    this.height,
    this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? 50,
      child: OutlinedButton(onPressed: onPressed, child: Text(text)),
    );
  }
}
