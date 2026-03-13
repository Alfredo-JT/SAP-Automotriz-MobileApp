import 'package:sap_automotriz_app/features/customers/domain/entities/car.dart';
import 'package:sap_automotriz_app/features/customers/domain/repositories/cars_repository.dart';
import 'package:sap_automotriz_app/features/customers/infrastructure/datasources/cars_datasource.dart';

class CarsRepositoryImpl extends CarsRepository {
  final CarsDatasource _datasource;

  CarsRepositoryImpl(this._datasource);

  @override
  Future<Car> getCarById(int id) {
    return _datasource.getCarById(id);
  }

  @override
  Future<List<Car>> getCarsByCustomerId(int customerId) {
    return _datasource.getCarsByCustomerId(customerId!);
  }

  @override
  Future<Car> createCar(Car car) {
    return _datasource.createCar(car);
  }

  @override
  Future<Car> updateCar(Car car) {
    return _datasource.updateCar(car);
  }

  @override
  Future<void> deleteCar(int id) {
    return _datasource.deleteCar(id);
  }
}
