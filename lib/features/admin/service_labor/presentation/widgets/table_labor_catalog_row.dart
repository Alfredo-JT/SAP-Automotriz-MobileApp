import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/admin/service_labor/domain/entities/labor_catalog.dart';
import 'package:sap_automotriz_app/features/shared/widgets/styled_icon_box.dart';

class TableLaborCatalogRow extends StatelessWidget {
  final LaborCatalog item;
  // final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TableLaborCatalogRow({
    required this.item,
    // required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = item.createdAt != null
        ? '${item.createdAt!.day.toString().padLeft(2, '0')}/${item.createdAt!.month.toString().padLeft(2, '0')}/${item.createdAt!.year}'
        : '—';

    return InkWell(
      // onTap: onView,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            // Nombre
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  StyledIconBox(
                    backgroundColor: AppColors.crimsonRed.withOpacity(0.08),
                    icon: Icons.build_outlined,
                    iconColor: AppColors.crimsonRed,
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.charcoal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            // Horas
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  const Icon(
                    Icons.schedule_outlined,
                    size: 13,
                    color: AppColors.warmGray,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${item.standardHours} hrs',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.charcoal,
                    ),
                  ),
                ],
              ),
            ),
            // Precio
            Expanded(
              flex: 2,
              child: Text(
                '\$ ${item.basePrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.charcoal,
                ),
              ),
            ),
            // Fecha
            Expanded(
              flex: 2,
              child: Text(
                dateStr,
                style: const TextStyle(fontSize: 13, color: AppColors.warmGray),
              ),
            ),
            // Acciones
            SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: AppColors.warmGray,
                    ),
                    tooltip: 'Editar',
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(6),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      size: 18,
                      color: AppColors.crimsonRed,
                    ),
                    tooltip: 'Eliminar',
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
