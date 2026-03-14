import 'package:sap_automotriz_app/features/users/domain/entities/user.dart';

abstract class UserAccountState {}

/// Estado inicial, antes de cualquier carga
class UserAccountInitial extends UserAccountState {}

/// Cargando lista o ejecutando una operación
class UserAccountLoading extends UserAccountState {}

/// Lista cargada correctamente
class UserAccountLoaded extends UserAccountState {
  final List<UserAccount> users;
  UserAccountLoaded(this.users);
}

/// Una operación (create/update/delete) se completó — lista actualizada
class UserAccountOperationSuccess extends UserAccountState {
  final List<UserAccount> users;
  final String message;
  UserAccountOperationSuccess({required this.users, required this.message});
}

/// Algo salió mal
class UserAccountError extends UserAccountState {
  final String message;
  UserAccountError(this.message);
}
