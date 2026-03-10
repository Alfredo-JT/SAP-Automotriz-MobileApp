import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/services/domain/entities/entities.dart';
import 'package:sap_automotriz_app/features/services/presentation/widgets/widgets.dart';

class ServiceQuotedCard extends StatelessWidget {
  final void Function()? onTap;
  final Service service;
  final bool selected;

  const ServiceQuotedCard({
    super.key,
    this.onTap,
    required this.service,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.crimsonRed.withOpacity(0.06)
                : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? AppColors.crimsonRed : const Color(0xFFEDE5DC),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    service.folio,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? AppColors.crimsonRed
                          : AppColors.charcoal,
                      letterSpacing: 1,
                    ),
                  ),
                  const Spacer(),

                  Icon(
                    channelIcon(service.channel),
                    size: 13,
                    color: AppColors.warmGray,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                service.customer?.fullName ?? '—',
                style: const TextStyle(fontSize: 12, color: AppColors.charcoal),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                service.car != null
                    ? '${service.car!.year} ${service.car!.make} ${service.car!.model}'
                    : '—',
                style: const TextStyle(fontSize: 11, color: AppColors.warmGray),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
