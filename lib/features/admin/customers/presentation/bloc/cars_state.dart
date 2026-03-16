import 'package:sap_automotriz_app/features/admin/customers/domain/entities/car.dart';

abstract class CarsState {}

/// Estado inicial, antes de cualquier carga
class CarsInitial extends CarsState {}

/// Cargando lista o ejecutando una operación
class CarsLoading extends CarsState {}

/// Lista cargada correctamente
class CarsLoaded extends CarsState {
  final List<Car> cars;
  CarsLoaded(this.cars);
}

/// Una operación (create/update/delete) se completó — lista actualizada
class CarsOperationSuccess extends CarsState {
  final List<Car> cars;
  final String message;
  CarsOperationSuccess({required this.cars, required this.message});
}

/// Algo salió mal
class CarsError extends CarsState {
  final String message;
  CarsError(this.message);
}
