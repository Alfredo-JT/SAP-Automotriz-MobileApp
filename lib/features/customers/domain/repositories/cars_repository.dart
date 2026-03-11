import 'package:sap_automotriz_app/features/customers/domain/entities/car.dart';

abstract class CarsRepository {
  // Future<List<Car>> getCars();
  Future<Car> getCarById(String id);
  Future<List<Car>> getCarsByCustomerId(String customerId);
  Future<void> createCar(Car car);
  Future<void> updateCar(Car car);
  Future<void> deleteCar(String id);
}
