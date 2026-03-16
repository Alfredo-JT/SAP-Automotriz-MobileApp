import 'package:sap_automotriz_app/features/admin/customers/domain/entities/car.dart';

abstract class CarsEvent {}

class CarsLoadRequested extends CarsEvent {
  final int customerId;
  CarsLoadRequested(this.customerId);
}

class CarCreateRequested extends CarsEvent {
  final Car car;
  CarCreateRequested(this.car);
}

class CarUpdateRequested extends CarsEvent {
  final Car car;
  CarUpdateRequested(this.car);
}

class CarDeleteRequested extends CarsEvent {
  final Car car;
  CarDeleteRequested(this.car);
}
