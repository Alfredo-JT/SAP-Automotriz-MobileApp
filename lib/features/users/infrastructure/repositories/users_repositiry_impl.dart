import 'package:sap_automotriz_app/features/users/domain/entities/user.dart';
import 'package:sap_automotriz_app/features/users/domain/repositories/users_repositiry.dart';
import 'package:sap_automotriz_app/features/users/infrastructure/datasources/users_datasource.dart';

class UsersRepositoryImpl extends UsersRepository {
  final UserAccountsDatasource _datasource;

  UsersRepositoryImpl(this._datasource);

  @override
  Future<UserAccount> createUser(UserAccount userAccount) {
    return _datasource.createUser(userAccount);
  }

  @override
  Future<void> deleteUser(int id) {
    return _datasource.deleteUser(id);
  }

  @override
  Future<List<UserAccount>> getAllUsers() {
    return _datasource.getAllUsers();
  }

  @override
  Future<UserAccount> getUserById(int id) {
    return _datasource.getUserById(id);
  }

  @override
  Future<UserAccount> updateUser(UserAccount userAccount) {
    return _datasource.updateUser(userAccount);
  }
}
