import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sap_automotriz_app/features/admin/customers/domain/repositories/cars_repository.dart';
import 'package:sap_automotriz_app/features/admin/customers/presentation/bloc/cars_event.dart';
import 'package:sap_automotriz_app/features/admin/customers/presentation/bloc/cars_state.dart';

class CarsBloc extends Bloc<CarsEvent, CarsState> {
  final CarsRepository _repository;

  CarsBloc(this._repository) : super(CarsInitial()) {
    on<CarsLoadRequested>(_onLoad);
    on<CarCreateRequested>(_onCreate);
    on<CarUpdateRequested>(_onUpdate);
    on<CarDeleteRequested>(_onDelete);
  }

  Future<void> _onLoad(CarsLoadRequested event, Emitter<CarsState> emit) async {
    emit(CarsLoading());
    try {
      final cars = await _repository.getCarsByCustomerId(event.customerId);
      emit(CarsLoaded(cars));
    } catch (e) {
      emit(CarsError('Error al cargar clientes: $e'));
    }
  }

  Future<void> _onCreate(
    CarCreateRequested event,
    Emitter<CarsState> emit,
  ) async {
    emit(CarsLoading());
    try {
      await _repository.createCar(event.car);
      final cars = await _repository.getCarsByCustomerId(event.car.customerId!);
      emit(
        CarsOperationSuccess(
          cars: cars,
          message: 'Cliente creado correctamente',
        ),
      );
    } catch (e) {
      emit(CarsError('Error al crear cliente: $e'));
    }
  }

  Future<void> _onUpdate(
    CarUpdateRequested event,
    Emitter<CarsState> emit,
  ) async {
    emit(CarsLoading());
    try {
      await _repository.updateCar(event.car);
      final cars = await _repository.getCarsByCustomerId(event.car.customerId!);
      emit(
        CarsOperationSuccess(
          cars: cars,
          message: 'Cliente actualizado correctamente',
        ),
      );
    } catch (e) {
      emit(CarsError('Error al actualizar cliente: $e'));
    }
  }

  Future<void> _onDelete(
    CarDeleteRequested event,
    Emitter<CarsState> emit,
  ) async {
    emit(CarsLoading());
    try {
      await _repository.deleteCar(event.car.id!);
      final cars = await _repository.getCarsByCustomerId(event.car.customerId!);
      emit(
        CarsOperationSuccess(
          cars: cars,
          message: 'Cliente eliminado correctamente',
        ),
      );
    } catch (e) {
      emit(CarsError('Error al eliminar cliente: $e'));
    }
  }
}
