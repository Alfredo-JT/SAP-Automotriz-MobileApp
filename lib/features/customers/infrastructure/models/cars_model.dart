import 'package:sap_automotriz_app/features/customers/domain/entities/car.dart';

class CarModel extends Car {
  const CarModel({
    super.id,
    required super.customerId,
    required super.make,
    required super.model,
    required super.year,
    required super.color,
    required super.licensePlate,
    super.createdAt,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'] as int?,
      customerId: json['customer_id'] as int,
      make: json['make'] as String,
      model: json['model'] as String,
      year: json['year'] as int,
      color: json['color'] as String,
      licensePlate: json['license_plate'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'customer_id': customerId,
      'make': make,
      'model': model,
      'year': year,
      'color': color,
      'license_plate': licensePlate,
      'created_at': createdAt != null ? createdAt!.toIso8601String() : null,
    };
  }

  factory CarModel.fromEntity(Car car) {
    return CarModel(
      id: car.id,
      customerId: car.customerId,
      make: car.make,
      model: car.model,
      year: car.year,
      color: car.color,
      licensePlate: car.licensePlate,
      createdAt: car.createdAt,
    );
  }
}
