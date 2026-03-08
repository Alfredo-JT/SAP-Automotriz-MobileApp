import 'package:flutter/material.dart';

class StyledIconBox extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;
  final Color? iconColor;

  const StyledIconBox({
    super.key,
    required this.backgroundColor,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: iconColor ?? Colors.white, size: 20),
    );
  }
}
