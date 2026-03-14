import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sap_automotriz_app/features/users/domain/repositories/users_repositiry.dart';
import 'package:sap_automotriz_app/features/users/presentation/bloc/user_event.dart';
import 'package:sap_automotriz_app/features/users/presentation/bloc/user_state.dart';

class UserAccountBloc extends Bloc<UserAccountEvent, UserAccountState> {
  final UsersRepository _repository;

  UserAccountBloc(this._repository) : super(UserAccountInitial()) {
    on<UserAccountLoadRequested>(_onLoad);
    on<UserAccountCreateRequested>(_onCreate);
    on<UserAccountUpdateRequested>(_onUpdate);
    on<UserAccountDeleteRequested>(_onDelete);
  }

  Future<void> _onLoad(
    UserAccountLoadRequested event,
    Emitter<UserAccountState> emit,
  ) async {
    emit(UserAccountLoading());
    try {
      final users = await _repository.getAllUsers();
      print('ON LOAD USERS:');
      print(users);
      emit(UserAccountLoaded(users));
    } catch (e) {
      emit(UserAccountError('Error al cargar usuarios: $e'));
    }
  }

  Future<void> _onCreate(
    UserAccountCreateRequested event,
    Emitter<UserAccountState> emit,
  ) async {
    emit(UserAccountLoading());
    try {
      await _repository.createUser(event.user);
      final users = await _repository.getAllUsers();
      emit(
        UserAccountOperationSuccess(
          users: users,
          message: 'Usuario creado correctamente',
        ),
      );
    } catch (e) {
      emit(UserAccountError('Error al crear usuario: $e'));
    }
  }

  Future<void> _onUpdate(
    UserAccountUpdateRequested event,
    Emitter<UserAccountState> emit,
  ) async {
    emit(UserAccountLoading());
    try {
      await _repository.updateUser(event.user);
      final users = await _repository.getAllUsers();
      emit(
        UserAccountOperationSuccess(
          users: users,
          message: 'Usuario actualizado correctamente',
        ),
      );
    } catch (e) {
      emit(UserAccountError('Error al actualizar usuario: $e'));
    }
  }

  Future<void> _onDelete(
    UserAccountDeleteRequested event,
    Emitter<UserAccountState> emit,
  ) async {
    emit(UserAccountLoading());
    try {
      await _repository.deleteUser(event.id);
      final users = await _repository.getAllUsers();
      emit(
        UserAccountOperationSuccess(
          users: users,
          message: 'Usuario eliminado correctamente',
        ),
      );
    } catch (e) {
      emit(UserAccountError('Error al eliminar usuario: $e'));
    }
  }
}
