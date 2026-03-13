import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sap_automotriz_app/config/router/app_router.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/customers/domain/entities/customer.dart';
import 'package:sap_automotriz_app/features/customers/infrastructure/datasources/cars_datasource.dart';
import 'package:sap_automotriz_app/features/customers/infrastructure/datasources/customers_datasource.dart';
import 'package:sap_automotriz_app/features/customers/infrastructure/repositories/cars_repository_impl.dart';
import 'package:sap_automotriz_app/features/customers/infrastructure/repositories/customers_repository_impl.dart';
import 'package:sap_automotriz_app/features/customers/presentation/bloc/blocs.dart';
import 'package:sap_automotriz_app/features/customers/presentation/widgets/widgets.dart';
import 'package:sap_automotriz_app/features/dashboard/presentation/widgets/admin_layout.dart';
import 'package:sap_automotriz_app/features/shared/widgets/widgets.dart';
import 'customer_detail_screen.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              CustomersBloc(CustomersRepositoryImpl(CustomersDatasource()))
                ..add(CustomersLoadRequested()),
        ),
        BlocProvider(
          create: (_) => CarsBloc(CarsRepositoryImpl(CarsDatasource())),
        ),
      ],
      child: const CustomersScreen(),
    );
  }
}

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Customer> _applySearch(List<Customer> customers) {
    if (_searchQuery.isEmpty) return customers;
    return customers.where((c) {
      return c.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (c.email?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
              false) ||
          c.phone.contains(_searchQuery);
    }).toList();
  }

  void _openCreate() async {
    final result = await showDialog<Customer>(
      context: context,

      builder: (_) => const CustomerFormDialog(),
    );
    if (result != null && mounted) {
      context.read<CustomersBloc>().add(CustomerCreateRequested(result));
    }
  }

  void _openEdit(Customer customer) async {
    final result = await showDialog<Customer>(
      context: context,
      builder: (_) => CustomerFormDialog(customer: customer),
    );
    if (result != null && mounted) {
      context.read<CustomersBloc>().add(CustomerUpdateRequested(result));
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
              Navigator.pop(context);
              context.read<CustomersBloc>().add(
                CustomerDeleteRequested(customer.id!),
              );
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
  Widget build(BuildContext context) {
    return BlocConsumer<CustomersBloc, CustomersState>(
      listener: (context, state) {
        if (state is CustomersOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFF16A34A),
            ),
          );
        }
        if (state is CustomersError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.crimsonRed,
            ),
          );
        }
      },
      builder: (context, state) {
        // Extraemos la lista de customers de cualquier estado que la tenga
        final customers = switch (state) {
          CustomersLoaded s => s.customers,
          CustomersOperationSuccess s => s.customers,
          _ => <Customer>[],
        };

        final filtered = _applySearch(customers);

        return AdminLayout(
          currentRoute: RouteNames.customers,
          pageTitle: 'Clientes',
          actions: [
            ElevatedButton.icon(
              onPressed: _openCreate,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Nuevo cliente'),
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              // Loading indicator
              if (state is CustomersLoading)
                const LinearProgressIndicator(
                  backgroundColor: Color(0xFFEDE5DC),
                  color: AppColors.crimsonRed,
                ),

              const SizedBox(height: 4),

              // Table header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
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
                    Expanded(
                      flex: 2,
                      child: TableHeaderCell('Fecha de creación'),
                    ),
                    SizedBox(width: 100, child: TableHeaderCell('Acciones')),
                  ],
                ),
              ),

              // Table body
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                  border: Border.all(color: const Color(0xFFEDE5DC)),
                ),
                child: state is CustomersInitial
                    ? const SizedBox.shrink()
                    : filtered.isEmpty && state is! CustomersLoading
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
                                builder: (_) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider.value(
                                      value: context.read<CustomersBloc>(),
                                    ),
                                    BlocProvider.value(
                                      value: context.read<CarsBloc>()
                                        ..add(CarsLoadRequested(c.id!)),
                                    ),
                                  ],
                                  child: CustomerDetailScreen(customer: c),
                                ),
                              ),
                            ),
                            onEdit: () => _openEdit(c),
                            onDelete: () => _confirmDelete(c),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 12),
              Text(
                '${filtered.length} cliente${filtered.length != 1 ? 's' : ''}',
                style: const TextStyle(fontSize: 13, color: AppColors.warmGray),
              ),
            ],
          ),
        );
      },
    );
  }
}
