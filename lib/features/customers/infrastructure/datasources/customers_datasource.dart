import 'package:sap_automotriz_app/features/customers/data/customers_mock.dart';
import 'package:sap_automotriz_app/features/customers/domain/entities/customer.dart';
import 'package:sap_automotriz_app/features/customers/infrastructure/models/customer_model.dart';

class CustomersDatasource {
  // Simula la base de datos local con los datos del mock
  final List<Map<String, dynamic>> _db = List.from(customersApiMock);

  Future<List<Customer>> getCustomers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _db.map((json) => CustomerModel.fromJson(json)).toList();
  }

  Future<Customer> getCustomerById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final json = _db.firstWhere(
      (c) => c['id'] == id,
      orElse: () => throw Exception('Cliente con id $id no encontrado'),
    );
    return CustomerModel.fromJson(json);
  }

  Future<Customer> createCustomer(Customer customer) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final newId =
        (_db.map((c) => c['id'] as int).reduce((a, b) => a > b ? a : b)) + 1;
    final now = DateTime.now().toIso8601String();
    final newJson = CustomerModel.fromEntity(customer).toJson()
      ..addAll({'id': newId, 'created_at': now, 'updated_at': now});
    _db.add(newJson);
    return CustomerModel.fromJson(newJson);
  }

  Future<Customer> updateCustomer(Customer customer) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final idx = _db.indexWhere((c) => c['id'] == customer.id);
    if (idx == -1)
      throw Exception('Cliente con id ${customer.id} no encontrado');
    final updated = CustomerModel.fromEntity(customer).toJson()
      ..addAll({
        'id': customer.id,
        'created_at': _db[idx]['created_at'],
        'updated_at': DateTime.now().toIso8601String(),
      });
    _db[idx] = updated;
    return CustomerModel.fromJson(updated);
  }

  Future<void> deleteCustomer(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _db.indexWhere((c) => c['id'] == id);
    if (idx == -1) throw Exception('Cliente con id $id no encontrado');
    _db.removeAt(idx);
  }
}
