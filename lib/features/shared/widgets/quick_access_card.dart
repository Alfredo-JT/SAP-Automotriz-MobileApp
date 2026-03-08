import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/shared/widgets/styled_icon_box.dart';

class QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;

  const QuickAccessCard({
    super.key,
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEDE5DC)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StyledIconBox(
                backgroundColor: AppColors.crimsonRed.withOpacity(0.1),
                icon: icon,
                iconColor: AppColors.crimsonRed,
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(fontSize: 12, color: AppColors.warmGray),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
