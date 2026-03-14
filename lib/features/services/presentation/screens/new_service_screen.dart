import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/core/utils/folio_generator.dart';
import 'package:sap_automotriz_app/features/customers/domain/entities/car.dart';
import 'package:sap_automotriz_app/features/customers/domain/entities/customer.dart';
import 'package:sap_automotriz_app/features/services/domain/entities/entities.dart';
import 'package:sap_automotriz_app/features/services/presentation/widgets/widgets.dart';
import 'package:sap_automotriz_app/features/shared/widgets/custom_dropdown_form.dart';
import 'package:sap_automotriz_app/features/shared/widgets/widgets.dart';

String _formatDate(DateTime dt) =>
    '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

class NewServiceScreen extends StatefulWidget {
  final bool standalone;
  const NewServiceScreen({super.key, this.standalone = true});

  @override
  State<NewServiceScreen> createState() => _NewServiceScreenState();
}

class _NewServiceScreenState extends State<NewServiceScreen> {
  final _formKey = GlobalKey<FormState>();

  // Mock customers — replace with BLoC
  final List<Customer> _customers = [
    Customer(
      id: 1,
      fullName: 'Carlos Ramírez',
      phone: '461-123-4567',
      email: 'carlos@example.com',
    ),
    Customer(id: 2, fullName: 'Laura González', phone: '461-987-6543'),
    Customer(id: 3, fullName: 'Roberto Hernández', phone: '461-555-7890'),
  ];

  // Mock cars per customer
  final Map<int, List<Car>> _carsByCustomer = {
    1: [
      Car(
        id: 1,
        customerId: 1,
        make: 'Nissan',
        model: 'Versa',
        year: 2019,
        color: 'Blanco',
        licensePlate: 'ABC-123',
      ),
      Car(
        id: 2,
        customerId: 1,
        make: 'Toyota',
        model: 'Corolla',
        year: 2021,
        color: 'Gris',
        licensePlate: 'XYZ-456',
      ),
    ],
    2: [
      Car(
        id: 3,
        customerId: 2,
        make: 'Chevrolet',
        model: 'Aveo',
        year: 2018,
        color: 'Rojo',
        licensePlate: 'DEF-789',
      ),
    ],
    3: [],
  };

  // Mock existing services today — for folio counter
  final List<Service> _todayServices = [];

  Customer? _selectedCustomer;
  Car? _selectedCar;
  ServiceChannel _channel = ServiceChannel.inPerson;
  ServiceType _serviceType = ServiceType.general;
  DateTime _intakeDate = DateTime.now();
  final _shortDescController = TextEditingController();
  final _detailedDescController = TextEditingController();

  String get _previewFolio {
    final sameDayCount =
        _todayServices
            .where(
              (s) =>
                  s.intakeDate.year == _intakeDate.year &&
                  s.intakeDate.month == _intakeDate.month &&
                  s.intakeDate.day == _intakeDate.day,
            )
            .length +
        1;
    return generateFolio(_intakeDate, sameDayCount);
  }

  List<Car> get _availableCars => _selectedCustomer != null
      ? (_carsByCustomer[_selectedCustomer!.id] ?? [])
      : [];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _intakeDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _intakeDate = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCustomer == null || _selectedCar == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona un cliente y un vehículo'),
          backgroundColor: AppColors.crimsonRed,
        ),
      );
      return;
    }

    // TODO: In real app, dispatch BLoC event
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Servicio $_previewFolio creado y enviado al Jefe de taller correctamente',
        ),
        backgroundColor: const Color(0xFF16A34A),
      ),
    );
    // Navigator.pop(context);
  }

  @override
  void dispose() {
    _shortDescController.dispose();
    _detailedDescController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Form ──────────────────────────────────────────────────────
        Expanded(
          flex: 3,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionCard(
                  title: 'Información del servicio',
                  icon: Icons.build_circle_outlined,
                  children: [
                    // Canal + Tipo
                    Row(
                      children: [
                        Expanded(
                          child: CustomDropdownForm<ServiceChannel>(
                            value: _channel,
                            items: ServiceChannel.values,
                            labelBuilder: (c) => c.label,
                            labelText: 'Canal de entrada *',
                            prefixIcon: Icons.input_rounded,
                            onChanged: (v) => setState(() => _channel = v!),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: CustomDropdownForm<ServiceType>(
                            value: _serviceType,
                            labelBuilder: (c) => c.label,
                            labelText: 'Tipo de servicio *',
                            prefixIcon: Icons.category_outlined,
                            items: ServiceType.values,
                            onChanged: (v) => setState(() => _serviceType = v!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Fecha recepción
                    GestureDetector(
                      onTap: _pickDate,
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Fecha de recepción *',
                            prefixIcon: const Icon(
                              Icons.calendar_today_outlined,
                            ),
                            suffixIcon: const Icon(
                              Icons.edit_calendar_outlined,
                            ),
                            hintText: _formatDate(_intakeDate),
                          ),
                          controller: TextEditingController(
                            text: _formatDate(_intakeDate),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Descripción breve
                    CustomTextFormField(
                      prefixIcon: Icon(Icons.short_text_rounded),
                      controller: _shortDescController,
                      text: 'Descripción breve *',
                      validatorFunction: (v) =>
                          v == null || v.isEmpty ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 14),

                    // // Descripción detallada
                    // CustomTextFormField(
                    //   prefixIcon: Icon(Icons.notes_rounded),
                    //   controller: _detailedDescController,
                    //   maxLines: 3,
                    //   text: 'Descripción detallada *',
                    // ),
                  ],
                ),

                const SizedBox(height: 16),

                SectionCard(
                  title: 'Cliente y vehículo',
                  icon: Icons.person_search_outlined,
                  children: [
                    // Cliente
                    DropdownButtonFormField<Customer>(
                      value: _selectedCustomer,
                      decoration: const InputDecoration(
                        labelText: 'Cliente *',
                        prefixIcon: Icon(Icons.person_outlined),
                      ),
                      hint: const Text('Selecciona un cliente'),
                      items: _customers
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(c.fullName),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() {
                        _selectedCustomer = v;
                        _selectedCar = null;
                      }),
                      validator: (v) =>
                          v == null ? 'Selecciona un cliente' : null,
                    ),
                    const SizedBox(height: 14),

                    // Vehículo
                    DropdownButtonFormField<Car>(
                      value: _selectedCar,
                      decoration: InputDecoration(
                        labelText: 'Vehículo *',
                        prefixIcon: const Icon(Icons.directions_car_outlined),
                        hintText: _selectedCustomer == null
                            ? 'Primero selecciona un cliente'
                            : _availableCars.isEmpty
                            ? 'El cliente no tiene vehículos'
                            : null,
                      ),
                      hint: Text(
                        _selectedCustomer == null
                            ? 'Primero selecciona un cliente'
                            : 'Selecciona un vehículo',
                        style: const TextStyle(
                          color: AppColors.warmGray,
                          fontSize: 13,
                        ),
                      ),
                      items: _availableCars
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(
                                '${c.year} ${c.make} ${c.model} — ${c.licensePlate}',
                              ),
                            ),
                          )
                          .toList(),
                      onChanged:
                          _selectedCustomer == null || _availableCars.isEmpty
                          ? null
                          : (v) => setState(() => _selectedCar = v),
                      validator: (v) =>
                          v == null ? 'Selecciona un vehículo' : null,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                CustomElevatedButton(
                  text: 'Crear servicio',
                  onPressed: _submit,
                  isLoading: false,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 24),

        // ── Preview panel ──────────────────────────────────────────────
        SizedBox(
          width: 280,
          child: Column(
            children: [
              // Status inicial
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFEDE5DC)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Estado inicial',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.warmGray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF7C3AED),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'En revisión',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.charcoal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.charcoal,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'FOLIO GENERADO',
                      style: TextStyle(
                        color: AppColors.warmGray,
                        fontSize: 10,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _previewFolio,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(_intakeDate),
                      style: const TextStyle(
                        color: AppColors.warmGray,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
