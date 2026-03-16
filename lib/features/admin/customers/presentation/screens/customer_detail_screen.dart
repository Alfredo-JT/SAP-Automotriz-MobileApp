import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sap_automotriz_app/config/router/app_router.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/admin/customers/domain/entities/car.dart';
import 'package:sap_automotriz_app/features/admin/customers/domain/entities/customer.dart';
import 'package:sap_automotriz_app/features/admin/customers/presentation/bloc/blocs.dart';
import 'package:sap_automotriz_app/features/admin/customers/presentation/widgets/widgets.dart';
import 'package:sap_automotriz_app/features/admin/shared/presentation/widgets/widgets.dart';

class CustomerDetailScreen extends StatefulWidget {
  final Customer customer;
  const CustomerDetailScreen({super.key, required this.customer});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  late Customer _customer;

  @override
  void initState() {
    super.initState();
    _customer = widget.customer;
  }

  void _editCustomer() async {
    final result = await showDialog<Customer>(
      context: context,
      builder: (_) => CustomerFormDialog(customer: _customer),
    );
    if (result != null && mounted) {
      context.read<CustomersBloc>().add(CustomerUpdateRequested(result));
    }
  }

  void _addCar() async {
    final result = await showDialog<Car>(
      context: context,
      builder: (_) => CarFormDialog(customerId: _customer.id!),
    );
    if (result != null && mounted) {
      context.read<CarsBloc>().add(CarCreateRequested(result));
    }
  }

  void _editCar(Car car) async {
    final result = await showDialog<Car>(
      context: context,
      builder: (_) => CarFormDialog(car: car, customerId: _customer.id!),
    );
    if (result != null && mounted) {
      context.read<CarsBloc>().add(CarUpdateRequested(result));
    }
  }

  void _confirmDeleteCar(Car car) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar vehículo'),
        content: Text(
          '¿Eliminar ${car.year} ${car.make} ${car.model} (${car.licensePlate})?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<CarsBloc>().add(CarDeleteRequested(car));
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
  Widget build(BuildContext context) {
    return BlocConsumer<CarsBloc, CarsState>(
      listener: (context, state) {},
      builder: (context, state) {
        // Extraemos la lista de customers de cualquier estado que la tenga
        final cars = switch (state) {
          CarsLoaded s => s.cars,
          CarsOperationSuccess s => s.cars,
          _ => <Car>[],
        };

        return AdminLayout(
          currentRoute: RouteNames.customers,
          pageTitle: 'Detalle de cliente',
          actions: [
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded, size: 16),
              label: const Text('Volver'),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _editCustomer,
              icon: const Icon(Icons.edit_rounded, size: 16),
              label: const Text('Editar cliente'),
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer info card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFEDE5DC)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.crimsonRed.withOpacity(0.1),
                      child: Text(
                        _customer.fullName[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.crimsonRed,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _customer.fullName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.charcoal,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 24,
                            runSpacing: 8,
                            children: [
                              InfoItem(
                                icon: Icons.phone_outlined,
                                label: 'Teléfono',
                                value: _customer.phone,
                              ),
                              InfoItem(
                                icon: Icons.email_outlined,
                                label: 'Correo',
                                value: _customer.email ?? '—',
                              ),
                              InfoItem(
                                icon: Icons.receipt_outlined,
                                label: 'RFC',
                                value: _customer.rfc ?? '—',
                              ),
                              if (_customer.createdAt != null)
                                InfoItem(
                                  icon: Icons.calendar_today_outlined,
                                  label: 'Cliente desde',
                                  value:
                                      '${_customer.createdAt!.day.toString().padLeft(2, '0')}/${_customer.createdAt!.month.toString().padLeft(2, '0')}/${_customer.createdAt!.year}',
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Cars section
              Row(
                children: [
                  const Text(
                    'Vehículos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.crimsonRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${cars.length}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.crimsonRed,
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: _addCar,
                    icon: const Icon(Icons.add_rounded, size: 16),
                    label: const Text('Agregar vehículo'),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              if (state is CarsLoading)
                Center(
                  child: const CircularProgressIndicator(
                    backgroundColor: Color(0xFFEDE5DC),
                    color: AppColors.crimsonRed,
                  ),
                ),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 320,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.6,
                ),
                itemCount: cars.length,
                itemBuilder: (_, i) => CarCard(
                  car: cars[i],
                  onEdit: () => _editCar(cars[i]),
                  onDelete: () => _confirmDeleteCar(cars[i]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
