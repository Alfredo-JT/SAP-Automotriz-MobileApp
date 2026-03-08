import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/router/app_router.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/dashboard/presentation/widgets/admin_layout.dart';
import 'package:sap_automotriz_app/features/service_labor/domain/entities/labor_catalog.dart';
import 'package:sap_automotriz_app/features/service_labor/presentation/widgets/labor_catalog_form_dialog.dart';
import 'package:sap_automotriz_app/features/shared/widgets/styled_icon_box.dart';
import 'labor_catalog_detail_screen.dart';

class LaborCatalogScreen extends StatefulWidget {
  const LaborCatalogScreen({super.key});

  @override
  State<LaborCatalogScreen> createState() => _LaborCatalogScreenState();
}

class _LaborCatalogScreenState extends State<LaborCatalogScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  // Mock data — replace with BLoC state
  final List<LaborCatalog> _items = [
    LaborCatalog(
      id: 1,
      name: 'Cambio de aceite y filtro',
      standardHours: 0.5,
      basePrice: 350.00,
      createdAt: DateTime(2024, 1, 10),
    ),
    LaborCatalog(
      id: 2,
      name: 'Alineación y balanceo',
      standardHours: 1.0,
      basePrice: 650.00,
      createdAt: DateTime(2024, 2, 5),
    ),
    LaborCatalog(
      id: 3,
      name: 'Cambio de frenos delanteros',
      standardHours: 2.5,
      basePrice: 1200.00,
      createdAt: DateTime(2024, 3, 18),
    ),
    LaborCatalog(
      id: 4,
      name: 'Diagnóstico computarizado',
      standardHours: 1.0,
      basePrice: 500.00,
      createdAt: DateTime(2024, 4, 1),
    ),
  ];

  List<LaborCatalog> get _filtered => _items
      .where((l) => l.name.toLowerCase().contains(_searchQuery.toLowerCase()))
      .toList();

  void _openCreate() async {
    final result = await showDialog<LaborCatalog>(
      context: context,
      builder: (_) => const LaborCatalogFormDialog(),
    );
    if (result != null) {
      setState(() => _items.add(result.copyWith(id: _items.length + 1)));
    }
  }

  void _openEdit(LaborCatalog item) async {
    final result = await showDialog<LaborCatalog>(
      context: context,
      builder: (_) => LaborCatalogFormDialog(labor: item),
    );
    if (result != null) {
      setState(() {
        final idx = _items.indexWhere((l) => l.id == item.id);
        if (idx != -1) _items[idx] = result;
      });
    }
  }

  void _confirmDelete(LaborCatalog item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar mano de obra'),
        content: Text(
          '¿Estás seguro de eliminar "${item.name}"? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _items.removeWhere((l) => l.id == item.id));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.crimsonRed,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return AdminLayout(
      currentRoute: RouteNames.laborCatalog,
      pageTitle: 'Catálogo de mano de obra',
      actions: [
        ElevatedButton.icon(
          onPressed: _openCreate,
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Nueva mano de obra'),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search
          SizedBox(
            width: 320,
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: const InputDecoration(
                hintText: 'Buscar por nombre...',
                prefixIcon: Icon(Icons.search_rounded),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 14,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.charcoal,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: const Row(
              children: [
                Expanded(flex: 5, child: _HeaderCell('Nombre')),
                Expanded(flex: 2, child: _HeaderCell('Horas estándar')),
                Expanded(flex: 2, child: _HeaderCell('Precio base')),
                Expanded(flex: 2, child: _HeaderCell('Creado')),
                SizedBox(width: 100, child: _HeaderCell('Acciones')),
              ],
            ),
          ),

          // Table rows
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
              border: Border.all(color: const Color(0xFFEDE5DC)),
            ),
            child: filtered.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Text(
                        'No se encontraron registros',
                        style: TextStyle(
                          color: AppColors.warmGray,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: Color(0xFFEDE5DC)),
                    itemBuilder: (context, i) {
                      final item = filtered[i];
                      return _LaborRow(
                        item: item,
                        onView: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                LaborCatalogDetailScreen(labor: item),
                          ),
                        ),
                        onEdit: () => _openEdit(item),
                        onDelete: () => _confirmDelete(item),
                      );
                    },
                  ),
          ),

          const SizedBox(height: 12),

          Text(
            '${filtered.length} registro${filtered.length != 1 ? 's' : ''}',
            style: const TextStyle(fontSize: 13, color: AppColors.warmGray),
          ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _LaborRow extends StatelessWidget {
  final LaborCatalog item;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _LaborRow({
    required this.item,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = item.createdAt != null
        ? '${item.createdAt!.day.toString().padLeft(2, '0')}/${item.createdAt!.month.toString().padLeft(2, '0')}/${item.createdAt!.year}'
        : '—';

    return InkWell(
      onTap: onView,
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
