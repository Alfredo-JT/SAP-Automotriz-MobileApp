import 'package:sap_automotriz_app/features/services/domain/entities/entities.dart';
import 'package:sap_automotriz_app/features/services/domain/repositories/services_repository.dart';
import 'package:sap_automotriz_app/features/services/infrastructure/datasources/services_datasource.dart';

class ServicesRepositoryImpl extends ServicesRepository {
  final ServicesDatasource _datasource;

  ServicesRepositoryImpl(this._datasource);

  @override
  Future<List<Service>> getServices() {
    return _datasource.getServices();
  }

  @override
  Future<List<ServiceWithQuote>> getQuotedServices() {
    return _datasource.getQuotedServices();
  }

  @override
  Future<Service> getServiceById(int id) {
    return _datasource.getServiceById(id);
  }

  @override
  Future<Service> createService(Service service) {
    return _datasource.createService(service);
  }

  @override
  Future<void> deleteService(int id) {
    return _datasource.deleteService(id);
  }

  @override
  Future<Service> updateService(Service service) {
    return _datasource.updateService(service);
  }
}
