import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/router/app_router.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/core/utils/folio_generator.dart';
import 'package:sap_automotriz_app/features/customers/domain/entities/car.dart';
import 'package:sap_automotriz_app/features/customers/domain/entities/customer.dart';
import 'package:sap_automotriz_app/features/dashboard/presentation/widgets/admin_layout.dart';
import 'package:sap_automotriz_app/features/services/domain/entities/entities.dart';

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

    // In real app, dispatch BLoC event
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Servicio $_previewFolio creado correctamente'),
        backgroundColor: const Color(0xFF16A34A),
      ),
    );
    Navigator.pop(context);
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
                _SectionCard(
                  title: 'Información del servicio',
                  icon: Icons.build_circle_outlined,
                  children: [
                    // Canal + Tipo
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<ServiceChannel>(
                            value: _channel,
                            decoration: const InputDecoration(
                              labelText: 'Canal de entrada *',
                              prefixIcon: Icon(Icons.input_rounded),
                            ),
                            items: ServiceChannel.values
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c.label),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) => setState(() => _channel = v!),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: DropdownButtonFormField<ServiceType>(
                            value: _serviceType,
                            decoration: const InputDecoration(
                              labelText: 'Tipo de servicio *',
                              prefixIcon: Icon(Icons.category_outlined),
                            ),
                            items: ServiceType.values
                                .map(
                                  (t) => DropdownMenuItem(
                                    value: t,
                                    child: Text(t.label),
                                  ),
                                )
                                .toList(),
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
                    TextFormField(
                      controller: _shortDescController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción breve *',
                        prefixIcon: Icon(Icons.short_text_rounded),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 14),

                    // Descripción detallada
                    TextFormField(
                      controller: _detailedDescController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Descripción detallada',
                        prefixIcon: Icon(Icons.notes_rounded),
                        alignLabelWithHint: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _SectionCard(
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

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: const Text('Crear servicio'),
                  ),
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

              const SizedBox(height: 14),

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

              // Resumen selección
              if (_selectedCustomer != null)
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
                        'Resumen',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.warmGray,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _PreviewRow(
                        icon: Icons.person_rounded,
                        label: _selectedCustomer!.fullName,
                      ),
                      if (_selectedCar != null) ...[
                        const SizedBox(height: 6),
                        _PreviewRow(
                          icon: Icons.directions_car_rounded,
                          label:
                              '${_selectedCar!.year} ${_selectedCar!.make} ${_selectedCar!.model}',
                        ),
                        const SizedBox(height: 6),
                        _PreviewRow(
                          icon: Icons.pin_outlined,
                          label: _selectedCar!.licensePlate,
                        ),
                      ],
                      const SizedBox(height: 6),
                      _PreviewRow(
                        icon: Icons.category_outlined,
                        label: _serviceType.label,
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

String _formatDate(DateTime dt) =>
    '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDE5DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.crimsonRed),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.charcoal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFEDE5DC)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _PreviewRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppColors.warmGray),
        const SizedBox(width: 7),
        Flexible(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.charcoal),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
