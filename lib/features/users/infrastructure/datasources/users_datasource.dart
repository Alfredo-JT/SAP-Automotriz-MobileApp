import 'package:sap_automotriz_app/features/users/domain/data/users_mock.dart';
import 'package:sap_automotriz_app/features/users/domain/entities/user.dart';
import 'package:sap_automotriz_app/features/users/infrastructure/models/users_model.dart';

class UserAccountsDatasource {
  // Simula la base de datos local con los datos del mock
  final List<Map<String, dynamic>> _db = List.from(mockUsers);

  Future<List<UserAccount>> getAllUsers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // print('DB MAP VALIS:');
    // print(_db);
    return _db.map((json) => UserAccountModel.fromJson(json)).toList();
  }

  Future<UserAccount> getUserById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final json = _db.firstWhere(
      (c) => c['id'] == id,
      orElse: () => throw Exception('Cliente con id $id no encontrado'),
    );
    return UserAccountModel.fromJson(json);
  }

  Future<UserAccount> createUser(UserAccount user) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final newId =
        (_db.map((c) => c['id'] as int).reduce((a, b) => a > b ? a : b)) + 1;
    final now = DateTime.now().toIso8601String();
    final newJson = UserAccountModel.fromEntity(user).toJson()
      ..addAll({'id': newId, 'created_at': now, 'updated_at': now});
    _db.add(newJson);
    return UserAccountModel.fromJson(newJson);
  }

  Future<UserAccount> updateUser(UserAccount user) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final idx = _db.indexWhere((c) => c['id'] == user.id);
    if (idx == -1) throw Exception('Cliente con id ${user.id} no encontrado');
    final updated = UserAccountModel.fromEntity(user).toJson()
      ..addAll({
        'id': user.id,
        'created_at': _db[idx]['created_at'],
        'updated_at': DateTime.now().toIso8601String(),
      });
    _db[idx] = updated;
    return UserAccountModel.fromJson(updated);
  }

  Future<void> deleteUser(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _db.indexWhere((c) => c['id'] == id);
    if (idx == -1) throw Exception('Cliente con id $id no encontrado');
    _db.removeAt(idx);
  }
}
