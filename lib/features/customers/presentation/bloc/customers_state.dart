import 'package:sap_automotriz_app/features/customers/domain/entities/customer.dart';

abstract class CustomersState {}

/// Estado inicial, antes de cualquier carga
class CustomersInitial extends CustomersState {}

/// Cargando lista o ejecutando una operación
class CustomersLoading extends CustomersState {}

/// Lista cargada correctamente
class CustomersLoaded extends CustomersState {
  final List<Customer> customers;
  CustomersLoaded(this.customers);
}

/// Una operación (create/update/delete) se completó — lista actualizada
class CustomersOperationSuccess extends CustomersState {
  final List<Customer> customers;
  final String message;
  CustomersOperationSuccess({required this.customers, required this.message});
}

/// Algo salió mal
class CustomersError extends CustomersState {
  final String message;
  CustomersError(this.message);
}
