import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/users/domain/entities/user.dart';

class TableUserRow extends StatelessWidget {
  final UserAccount user;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TableUserRow({
    required this.user,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = user.role.color;

    return InkWell(
      onTap: onView,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        child: Row(
          children: [
            // Nombre
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: color.withOpacity(0.12),
                    child: Text(
                      user.fullName[0].toUpperCase(),
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      user.fullName,
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
            // Email
            Expanded(
              flex: 3,
              child: Text(
                user.email ?? '—',
                style: const TextStyle(fontSize: 13, color: AppColors.warmGray),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Teléfono
            Expanded(
              flex: 2,
              child: Text(
                user.phone,
                style: const TextStyle(fontSize: 13, color: AppColors.charcoal),
              ),
            ),
            // Rol badge
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  user.role.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            // Salario
            Expanded(
              flex: 2,
              child: Text(
                user.salary != null
                    ? '\$ ${user.salary!.toStringAsFixed(2)}'
                    : '—',
                style: const TextStyle(fontSize: 13, color: AppColors.charcoal),
              ),
            ),
            // Estado
            Expanded(
              flex: 1,
              child: Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: user.isActive
                      ? const Color(0xFF16A34A)
                      : AppColors.warmGray,
                ),
              ),
            ),
            // Acciones
            SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                    onPressed: onView,
                    icon: const Icon(
                      Icons.visibility_outlined,
                      size: 18,
                      color: AppColors.warmGray,
                    ),
                    tooltip: 'Ver detalle',
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(6),
                  ),
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
