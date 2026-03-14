import 'package:sap_automotriz_app/features/users/domain/entities/user.dart';

abstract class UserAccountEvent {}

class UserAccountLoadRequested extends UserAccountEvent {}

class UserAccountCreateRequested extends UserAccountEvent {
  final UserAccount user;
  UserAccountCreateRequested(this.user);
}

class UserAccountUpdateRequested extends UserAccountEvent {
  final UserAccount user;
  UserAccountUpdateRequested(this.user);
}

class UserAccountDeleteRequested extends UserAccountEvent {
  final int id;
  UserAccountDeleteRequested(this.id);
}
