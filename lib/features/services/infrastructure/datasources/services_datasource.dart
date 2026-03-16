import 'package:sap_automotriz_app/features/services/data/services_quoted_mock.dart';
import 'package:sap_automotriz_app/features/services/domain/entities/entities.dart';
import 'package:sap_automotriz_app/features/services/infrastructure/models/service_model.dart';
import 'package:sap_automotriz_app/features/services/infrastructure/models/service_with_quote_model.dart';

class ServicesDatasource {
  // Simula la base de datos local con los datos del mock
  final List<Map<String, dynamic>> _db = List.from([]);
  final List<Map<String, dynamic>> _db2 = List.from(quotedServicesMock);

  Future<List<Service>> getServices() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _db.map((json) => ServiceModel.fromJson(json)).toList();
  }

  Future<List<ServiceWithQuote>> getQuotedServices() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _db2.map((json) => ServiceWithQuoteModel.fromJson(json)).toList();
  }

  Future<Service> getServiceById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final json = _db.firstWhere(
      (c) => c['id'] == id,
      orElse: () => throw Exception('Carro con id $id no encontrado'),
    );
    return ServiceModel.fromJson(json);
  }

  Future<Service> createService(Service service) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final newId =
        (_db.map((c) => c['id'] as int).reduce((a, b) => a > b ? a : b)) + 1;
    final now = DateTime.now().toIso8601String();
    final newJson = ServiceModel.fromEntity(service).toJson()
      ..addAll({'id': newId, 'created_at': now, 'updated_at': now});
    _db.add(newJson);
    return ServiceModel.fromJson(newJson);
  }

  Future<Service> updateService(Service service) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final idx = _db.indexWhere((c) => c['id'] == service.id);
    if (idx == -1) {
      throw Exception('Servicio con id ${service.id} no encontrado');
    }
    final updated = ServiceModel.fromEntity(service).toJson()
      ..addAll({
        'id': service.id,
        'created_at': _db[idx]['created_at'],
        'updated_at': DateTime.now().toIso8601String(),
      });
    _db[idx] = updated;
    return ServiceModel.fromJson(updated);
  }

  Future<void> deleteService(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _db.indexWhere((service) => service['id'] == id);
    if (idx == -1) throw Exception('Servicio con id $id no encontrado');
    _db.removeAt(idx);
  }
}
