import 'package:sap_automotriz_app/features/customers/domain/entities/car.dart';
import 'package:sap_automotriz_app/features/customers/domain/repositories/cars_repository.dart';

class CarsRepositoryImpl extends CarsRepository {
  @override
  Future<List<Car>> getCars() {
    // TODO: implement getCars
    throw UnimplementedError();
  }

  @override
  Future<Car> getCarById(String id) {
    // TODO: implement getCarById
    throw UnimplementedError();
  }

  @override
  Future<void> createCar(Car car) {
    // TODO: implement createCar
    throw UnimplementedError();
  }

  @override
  Future<void> updateCar(Car car) {
    // TODO: implement updateCar
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCar(String id) {
    // TODO: implement deleteCar
    throw UnimplementedError();
  }

  @override
  Future<List<Car>> getCarsByCustomerId(String customerId) {
    // TODO: implement getCarsByCustomerId
    throw UnimplementedError();
  }
}
