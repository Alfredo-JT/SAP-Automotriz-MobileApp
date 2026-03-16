import 'package:sap_automotriz_app/features/services/domain/entities/entities.dart';

abstract class ServicesState {}

/// Estado inicial, antes de cualquier carga
class ServicesInitial extends ServicesState {}

/// Cargando lista o ejecutando una operación
class ServicesLoading extends ServicesState {}

/// Lista cargada correctamente
class ServicesLoaded extends ServicesState {
  final List<Service> service;
  ServicesLoaded(this.service);
}

/// Una operación (create/update/delete) se completó — lista actualizada
class ServiceOperationSuccess extends ServicesState {
  final Service service;
  final String message;
  ServiceOperationSuccess({required this.service, required this.message});
}

/// Algo salió mal
class ServicesError extends ServicesState {
  final String message;
  ServicesError(this.message);
}
