import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sap_automotriz_app/features/admin/customers/domain/repositories/customers_repository.dart';
import 'customers_event.dart';
import 'customers_state.dart';

class CustomersBloc extends Bloc<CustomersEvent, CustomersState> {
  final CustomersRepository _repository;

  CustomersBloc(this._repository) : super(CustomersInitial()) {
    on<CustomersLoadRequested>(_onLoad);
    on<CustomerCreateRequested>(_onCreate);
    on<CustomerUpdateRequested>(_onUpdate);
    on<CustomerDeleteRequested>(_onDelete);
  }

  Future<void> _onLoad(
    CustomersLoadRequested event,
    Emitter<CustomersState> emit,
  ) async {
    emit(CustomersLoading());
    try {
      final customers = await _repository.getCustomers();
      emit(CustomersLoaded(customers));
    } catch (e) {
      emit(CustomersError('Error al cargar clientes: $e'));
    }
  }

  Future<void> _onCreate(
    CustomerCreateRequested event,
    Emitter<CustomersState> emit,
  ) async {
    emit(CustomersLoading());
    try {
      await _repository.createCustomer(event.customer);
      final customers = await _repository.getCustomers();
      emit(
        CustomersOperationSuccess(
          customers: customers,
          message: 'Cliente creado correctamente',
        ),
      );
    } catch (e) {
      emit(CustomersError('Error al crear cliente: $e'));
    }
  }

  Future<void> _onUpdate(
    CustomerUpdateRequested event,
    Emitter<CustomersState> emit,
  ) async {
    emit(CustomersLoading());
    try {
      await _repository.updateCustomer(event.customer);
      final customers = await _repository.getCustomers();
      emit(
        CustomersOperationSuccess(
          customers: customers,
          message: 'Cliente actualizado correctamente',
        ),
      );
    } catch (e) {
      emit(CustomersError('Error al actualizar cliente: $e'));
    }
  }

  Future<void> _onDelete(
    CustomerDeleteRequested event,
    Emitter<CustomersState> emit,
  ) async {
    emit(CustomersLoading());
    try {
      await _repository.deleteCustomer(event.id);
      final customers = await _repository.getCustomers();
      emit(
        CustomersOperationSuccess(
          customers: customers,
          message: 'Cliente eliminado correctamente',
        ),
      );
    } catch (e) {
      emit(CustomersError('Error al eliminar cliente: $e'));
    }
  }
}
