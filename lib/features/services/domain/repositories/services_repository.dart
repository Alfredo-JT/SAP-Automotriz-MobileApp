import 'package:sap_automotriz_app/features/services/domain/entities/entities.dart';

abstract class ServicesRepository {
  Future<List<Service>> getService();
  Future<Service> getServiceById(int id);
  Future<Service> createService(Service service);
  Future<Service> updateService(Service service);
  Future<void> deleteService(int id);
}
