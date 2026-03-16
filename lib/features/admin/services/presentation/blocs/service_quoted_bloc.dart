import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sap_automotriz_app/features/services/domain/repositories/services_repository.dart';
import 'package:sap_automotriz_app/features/admin/services/presentation/blocs/service_event.dart';
import 'package:sap_automotriz_app/features/admin/services/presentation/blocs/service_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final ServicesRepository _repository;

  ServicesBloc(this._repository) : super(ServicesInitial()) {
    on<ServicesLoadRequested>(_onLoad);
    on<ServiceCreateRequested>(_onCreate);
    on<ServiceUpdateRequested>(_onUpdate);
    on<ServiceDeleteRequested>(_onDelete);
  }

  Future<void> _onLoad(
    ServicesLoadRequested event,
    Emitter<ServicesState> emit,
  ) async {
    emit(ServicesLoading());
    try {
      final services = await _repository.getServices();
      emit(ServicesLoaded(services));
    } catch (e) {
      emit(ServicesError('Error al cargar servicios: $e'));
    }
  }

  Future<void> _onCreate(
    ServiceCreateRequested event,
    Emitter<ServicesState> emit,
  ) async {
    emit(ServicesLoading());
    try {
      await _repository.createService(event.service);
      // final services = await _repository.getServicesByCustomerId(
      //   event.service.customerId,
      // );
      final service = await _repository.getServiceById(event.service.id!);
      emit(
        ServiceOperationSuccess(
          service: service,
          message: 'Servicio creado correctamente',
        ),
      );
    } catch (e) {
      emit(ServicesError('Error al crear servicio: $e'));
    }
  }

  Future<void> _onUpdate(
    ServiceUpdateRequested event,
    Emitter<ServicesState> emit,
  ) async {
    emit(ServicesLoading());
    try {
      await _repository.updateService(event.service);
      final service = await _repository.getServiceById(event.service.id!);
      emit(
        ServiceOperationSuccess(
          service: service,
          message: 'Servicio actualizado correctamente',
        ),
      );
    } catch (e) {
      emit(ServicesError('Error al actualizar servicio: $e'));
    }
  }

  Future<void> _onDelete(
    ServiceDeleteRequested event,
    Emitter<ServicesState> emit,
  ) async {
    emit(ServicesLoading());
    try {
      await _repository.deleteService(event.service.id!);
      final service = await _repository.getServiceById(event.service.id!);
      emit(
        ServiceOperationSuccess(
          service: service,
          message: 'Servicio eliminado correctamente',
        ),
      );
    } catch (e) {
      emit(ServicesError('Error al eliminar servicio: $e'));
    }
  }
}
