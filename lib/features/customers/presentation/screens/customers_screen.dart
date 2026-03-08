import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/router/app_router.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/customers/domain/entities/customer.dart';
import 'package:sap_automotriz_app/features/dashboard/presentation/widgets/admin_layout.dart';
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
                Expanded(flex: 3, child: _HeaderCell('Nombre')),
                Expanded(flex: 3, child: _HeaderCell('Correo')),
                Expanded(flex: 2, child: _HeaderCell('Teléfono')),
                Expanded(flex: 2, child: _HeaderCell('RFC')),
                Expanded(flex: 2, child: _HeaderCell('Registro')),
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
                      return _CustomerRow(
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

class _CustomerRow extends StatelessWidget {
  final Customer customer;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CustomerRow({
    required this.customer,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final created = customer.createdAt;
    final dateStr = created != null
        ? '${created.day.toString().padLeft(2, '0')}/${created.month.toString().padLeft(2, '0')}/${created.year}'
        : '—';

    return InkWell(
      onTap: onView,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.crimsonRed.withOpacity(0.1),
                    child: Text(
                      customer.fullName[0].toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.crimsonRed,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      customer.fullName,
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
            Expanded(
              flex: 3,
              child: Text(
                customer.email ?? '—',
                style: const TextStyle(fontSize: 13, color: AppColors.warmGray),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                customer.phone,
                style: const TextStyle(fontSize: 13, color: AppColors.charcoal),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                customer.rfc ?? '—',
                style: const TextStyle(fontSize: 13, color: AppColors.warmGray),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                dateStr,
                style: const TextStyle(fontSize: 13, color: AppColors.warmGray),
              ),
            ),
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
