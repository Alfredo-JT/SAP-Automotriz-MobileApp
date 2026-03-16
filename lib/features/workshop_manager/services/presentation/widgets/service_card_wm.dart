import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';

class ServiceCardWm extends StatelessWidget {
  final Map<String, dynamic> service;
  final String primaryActionLabel;
  final IconData primaryActionIcon;
  final Color primaryActionColor;
  final VoidCallback onPrimaryAction;
  final Widget? bottomInfo;
  final List<SecondaryAction>? secondaryActions;

  const ServiceCardWm({
    super.key,
    required this.service,
    required this.primaryActionLabel,
    required this.primaryActionIcon,
    required this.primaryActionColor,
    required this.onPrimaryAction,
    this.bottomInfo,
    this.secondaryActions,
  });

  IconData get _channelIcon {
    switch (service['channel']) {
      case 'whatsapp':
        return Icons.chat_bubble_rounded;
      case 'phone_call':
        return Icons.phone_rounded;
      default:
        return Icons.store_rounded;
    }
  }

  Color get _statusColor {
    switch (service['status']) {
      case 'not_started':
        return AppColors.warmGray;
      case 'under_review':
        return const Color(0xFF7C3AED);
      case 'quoted':
        return const Color(0xFF2563EB);
      case 'authorized':
        return AppColors.golden;
      case 'in_progress':
        return const Color(0xFFEA580C);
      case 'completed':
        return const Color(0xFF16A34A);
      default:
        return AppColors.warmGray;
    }
  }

  String get _statusLabel {
    switch (service['status']) {
      case 'not_started':
        return 'Sin iniciar';
      case 'under_review':
        return 'En revisión';
      case 'quoted':
        return 'Cotizado';
      case 'authorized':
        return 'Autorizado';
      case 'in_progress':
        return 'En proceso';
      case 'completed':
        return 'Completado';
      default:
        return service['status'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDE5DC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: primaryActionColor.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(13),
              ),
              border: Border(
                bottom: BorderSide(color: primaryActionColor.withOpacity(0.15)),
              ),
            ),
            child: Row(
              children: [
                Text(
                  service['folio'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: primaryActionColor,
                    letterSpacing: 1,
                  ),
                ),
                const Spacer(),
                Icon(_channelIcon, size: 14, color: AppColors.warmGray),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _statusLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service['shortDescription'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline_rounded,
                      size: 13,
                      color: AppColors.warmGray,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      service['customerName'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.warmGray,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.directions_car_outlined,
                      size: 13,
                      color: AppColors.warmGray,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        service['carLabel'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.warmGray,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 13,
                      color: AppColors.warmGray,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      service['intakeDate'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.warmGray,
                      ),
                    ),
                  ],
                ),
                if (bottomInfo != null) ...[
                  const SizedBox(height: 8),
                  bottomInfo!,
                ],
              ],
            ),
          ),

          // Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              children: [
                if (secondaryActions != null) ...[
                  Row(
                    children: secondaryActions!
                        .map(
                          (a) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: OutlinedButton.icon(
                                onPressed: a.onTap,
                                icon: Icon(a.icon, size: 14),
                                label: Text(
                                  a.label,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: a.color,
                                  side: BorderSide(color: a.color),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                ],
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onPrimaryAction,
                    icon: Icon(primaryActionIcon, size: 16),
                    label: Text(primaryActionLabel),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryActionColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SecondaryAction {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const SecondaryAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
