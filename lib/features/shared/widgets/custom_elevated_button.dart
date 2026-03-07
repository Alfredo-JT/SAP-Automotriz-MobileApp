import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final double? height;
  final bool _isLoading;
  final void Function()? onPressed;

  const CustomElevatedButton({
    super.key,
    required this.text,
    this.onPressed,
    required bool isLoading,
    this.height,
  }) : _isLoading = isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(text),
      ),
    );
  }
}
