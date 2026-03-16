import 'package:sap_automotriz_app/features/admin/customers/domain/entities/car.dart';

abstract class CarsRepository {
  // Future<List<Car>> getCars();
  Future<Car> getCarById(int id);
  Future<List<Car>> getCarsByCustomerId(int customerId);
  Future<void> createCar(Car car);
  Future<void> updateCar(Car car);
  Future<void> deleteCar(int id);
}
