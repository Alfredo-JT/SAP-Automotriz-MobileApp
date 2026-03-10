import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/services/domain/entities/entities.dart';
import 'package:sap_automotriz_app/features/services/presentation/widgets/widgets.dart';

class ServiceQuotedHeader extends StatelessWidget {
  final Service service;
  final DateTime? estimatedDelivery;
  final VoidCallback onPickDeliveryDate;

  const ServiceQuotedHeader({
    super.key,
    required this.service,
    required this.onPickDeliveryDate,
    this.estimatedDelivery,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDE5DC)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service.folio,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.charcoal,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                service.shortDescription,
                style: const TextStyle(fontSize: 13, color: AppColors.warmGray),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: onPickDeliveryDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: estimatedDelivery != null
                      ? AppColors.crimsonRed
                      : AppColors.warmGray,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.event_outlined,
                    size: 15,
                    color: estimatedDelivery != null
                        ? AppColors.crimsonRed
                        : AppColors.warmGray,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    estimatedDelivery != null
                        ? 'Entrega: ${formatDate(estimatedDelivery)}'
                        : 'Fecha entrega estimada',
                    style: TextStyle(
                      fontSize: 13,
                      color: estimatedDelivery != null
                          ? AppColors.crimsonRed
                          : AppColors.warmGray,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          ServiceStatusBadge(status: service.status),
        ],
      ),
    );
  }
}
