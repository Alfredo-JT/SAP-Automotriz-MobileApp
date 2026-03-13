import 'package:sap_automotriz_app/features/customers/data/cars_mock.dart';
import 'package:sap_automotriz_app/features/customers/domain/entities/car.dart';
import 'package:sap_automotriz_app/features/customers/infrastructure/models/cars_model.dart';

class CarsDatasource {
  // Simula la base de datos local con los datos del mock
  final List<Map<String, dynamic>> _db = List.from(carsApiMock);

  Future<Car> getCarById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final json = _db.firstWhere(
      (c) => c['id'] == id,
      orElse: () => throw Exception('Carro con id $id no encontrado'),
    );
    return CarModel.fromJson(json);
  }

  Future<List<Car>> getCarsByCustomerId(int customerId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _db
        .where((c) => c['customer_id'] == customerId)
        .map((json) => CarModel.fromJson(json))
        .toList();
  }

  Future<Car> createCar(Car car) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final newId =
        (_db.map((c) => c['id'] as int).reduce((a, b) => a > b ? a : b)) + 1;
    final now = DateTime.now().toIso8601String();
    final newJson = CarModel.fromEntity(car).toJson()
      ..addAll({'id': newId, 'created_at': now, 'updated_at': now});
    _db.add(newJson);
    return CarModel.fromJson(newJson);
  }

  Future<Car> updateCar(Car car) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final idx = _db.indexWhere((c) => c['id'] == car.id);
    if (idx == -1) {
      throw Exception('Carro del cliente con id ${car.id} no encontrado');
    }
    final updated = CarModel.fromEntity(car).toJson()
      ..addAll({
        'id': car.id,
        'created_at': _db[idx]['created_at'],
        'updated_at': DateTime.now().toIso8601String(),
      });
    _db[idx] = updated;
    return CarModel.fromJson(updated);
  }

  Future<void> deleteCar(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _db.indexWhere((c) => c['id'] == id);
    if (idx == -1) throw Exception('Carro con id $id no encontrado');
    _db.removeAt(idx);
  }
}
