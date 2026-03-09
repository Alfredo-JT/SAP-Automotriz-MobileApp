import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/router/app_router.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/customers/domain/entities/customer.dart';
import 'package:sap_automotriz_app/features/customers/presentation/widgets/table_customer_row.dart';
import 'package:sap_automotriz_app/features/dashboard/presentation/widgets/admin_layout.dart';
import 'package:sap_automotriz_app/features/shared/widgets/widgets.dart';
import 'customer_detail_screen.dart';
import '../widgets/customer_form_dialog.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  // Mock data — replace with BLoC state
  final List<Customer> _customers = [
    Customer(
      id: 1,
      fullName: 'Carlos Ramírez',
      phone: '461-123-4567',
      email: 'carlos@example.com',
      rfc: 'RAMC850101',
      createdAt: DateTime(2024, 3, 10),
    ),
    Customer(
      id: 2,
      fullName: 'Laura González',
      phone: '461-987-6543',
      email: 'laura@example.com',
      createdAt: DateTime(2024, 5, 22),
    ),
    Customer(
      id: 3,
      fullName: 'Roberto Hernández',
      phone: '461-555-7890',
      email: 'roberto@example.com',
      rfc: 'HERO790312',
      createdAt: DateTime(2025, 1, 5),
    ),
  ];

  List<Customer> get _filtered => _customers
      .where(
        (c) =>
            c.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (c.email?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
                false) ||
            c.phone.contains(_searchQuery),
      )
      .toList();

  void _openCreateDialog() async {
    final result = await showDialog<Customer>(
      context: context,
      builder: (_) => const CustomerFormDialog(),
    );
    if (result != null) {
      setState(() {
        _customers.add(result.copyWith(id: _customers.length + 1));
      });
    }
  }

  void _openEditDialog(Customer customer) async {
    final result = await showDialog<Customer>(
      context: context,
      builder: (_) => CustomerFormDialog(customer: customer),
    );
    if (result != null) {
      setState(() {
        final idx = _customers.indexWhere((c) => c.id == customer.id);
        if (idx != -1) _customers[idx] = result;
      });
    }
  }

  void _confirmDelete(Customer customer) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar cliente'),
        content: Text(
          '¿Estás seguro de eliminar a ${customer.fullName}? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(
                () => _customers.removeWhere((c) => c.id == customer.id),
              );
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
      currentRoute: RouteNames.customers,
      pageTitle: 'Clientes',
      actions: [
        ElevatedButton.icon(
          onPressed: _openCreateDialog,
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Nuevo cliente'),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          SizedBox(
            width: 320,
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: const InputDecoration(
                hintText: 'Buscar por nombre, email o teléfono...',
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
                Expanded(flex: 3, child: TableHeaderCell('Nombre')),
                Expanded(flex: 3, child: TableHeaderCell('Correo')),
                Expanded(flex: 2, child: TableHeaderCell('Teléfono')),
                Expanded(flex: 2, child: TableHeaderCell('RFC')),
                Expanded(flex: 2, child: TableHeaderCell('Registro')),
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
                        'No se encontraron clientes',
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
                    itemBuilder: (context, index) {
                      final c = filtered[index];
                      return TableCustomerRow(
                        customer: c,
                        onView: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CustomerDetailScreen(customer: c),
                          ),
                        ),
                        onEdit: () => _openEditDialog(c),
                        onDelete: () => _confirmDelete(c),
                      );
                    },
                  ),
          ),

          const SizedBox(height: 12),

          Text(
            '${filtered.length} cliente${filtered.length != 1 ? 's' : ''} encontrado${filtered.length != 1 ? 's' : ''}',
            style: const TextStyle(fontSize: 13, color: AppColors.warmGray),
          ),
        ],
      ),
    );
  }
}
