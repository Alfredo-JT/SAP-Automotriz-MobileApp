import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/router/app_router.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/admin/shared/presentation/widgets/admin_layout.dart';
import 'package:sap_automotriz_app/features/admin/service_labor/domain/entities/labor_catalog.dart';
import 'package:sap_automotriz_app/features/admin/service_labor/presentation/widgets/widgets.dart';
import 'package:sap_automotriz_app/features/shared/widgets/widgets.dart';

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
      name: 'Cambio de aceite y filtro 2',
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
                Expanded(flex: 5, child: TableHeaderCell('Nombre')),
                Expanded(flex: 2, child: TableHeaderCell('Horas estándar')),
                Expanded(flex: 2, child: TableHeaderCell('Precio base')),
                Expanded(flex: 2, child: TableHeaderCell('Creado')),
                SizedBox(width: 100, child: TableHeaderCell('Acciones')),
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
                      return TableLaborCatalogRow(
                        item: item,
                        // onView: () => Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) =>
                        //         LaborCatalogDetailScreen(labor: item),
                        //   ),
                        // ),
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
