import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/router/app_router.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/customers/domain/entities/car.dart';
import 'package:sap_automotriz_app/features/customers/domain/entities/customer.dart';
import 'package:sap_automotriz_app/features/customers/presentation/widgets/widgets.dart';
import 'package:sap_automotriz_app/features/dashboard/presentation/widgets/widgets.dart';

class CustomerDetailScreen extends StatefulWidget {
  final Customer customer;
  const CustomerDetailScreen({super.key, required this.customer});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  late Customer _customer;

  // Mock cars — replace with BLoC
  final List<Car> _cars = [
    Car(
      id: 1,
      customerId: 1,
      make: 'Nissan',
      model: 'Versa',
      year: 2019,
      color: 'Blanco',
      licensePlate: 'ABC-123',
      createdAt: DateTime(2024, 3, 10),
    ),
  ];

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
    if (result != null) setState(() => _customer = result);
  }

  void _addCar() async {
    final result = await showDialog<Car>(
      context: context,
      builder: (_) => CarFormDialog(customerId: _customer.id!),
    );
    if (result != null) {
      setState(() => _cars.add(result.copyWith(id: _cars.length + 1)));
    }
  }

  void _editCar(Car car) async {
    final result = await showDialog<Car>(
      context: context,
      builder: (_) => CarFormDialog(car: car, customerId: _customer.id!),
    );
    if (result != null) {
      setState(() {
        final idx = _cars.indexWhere((c) => c.id == car.id);
        if (idx != -1) _cars[idx] = result;
      });
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
              setState(() => _cars.removeWhere((c) => c.id == car.id));
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
                          _InfoItem(
                            icon: Icons.phone_outlined,
                            label: 'Teléfono',
                            value: _customer.phone,
                          ),
                          _InfoItem(
                            icon: Icons.email_outlined,
                            label: 'Correo',
                            value: _customer.email ?? '—',
                          ),
                          _InfoItem(
                            icon: Icons.receipt_outlined,
                            label: 'RFC',
                            value: _customer.rfc ?? '—',
                          ),
                          if (_customer.createdAt != null)
                            _InfoItem(
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.crimsonRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_cars.length}',
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

          _cars.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFEDE5DC),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: const Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.directions_car_outlined,
                          size: 40,
                          color: AppColors.warmGray,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Este cliente no tiene vehículos registrados',
                          style: TextStyle(
                            color: AppColors.warmGray,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 320,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.6,
                  ),
                  itemCount: _cars.length,
                  itemBuilder: (_, i) => CarCard(
                    car: _cars[i],
                    onEdit: () => _editCar(_cars[i]),
                    onDelete: () => _confirmDeleteCar(_cars[i]),
                  ),
                ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.warmGray),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppColors.warmGray),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.charcoal,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
