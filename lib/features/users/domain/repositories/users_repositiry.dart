import 'package:sap_automotriz_app/features/users/domain/entities/user.dart';

abstract class UsersRepository {
  Future<List<UserAccount>> getAllUsers();
  Future<UserAccount> getUserById(int id);
  Future<UserAccount> createUser(UserAccount userAccount);
  Future<UserAccount> updateUser(UserAccount userAccount);
  Future<void> deleteUser(int id);
}
