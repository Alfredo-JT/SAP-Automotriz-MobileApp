class Car {
  final int? id;
  final int? customerId;
  final String make;
  final String model;
  final int year;
  final String color;
  final String licensePlate;
  final String? vin;
  final DateTime? createdAt;

  const Car({
    this.id,
    this.customerId,
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.licensePlate,
    this.vin,
    this.createdAt,
  });

  Car copyWith({
    int? id,
    int? customerId,
    String? make,
    String? model,
    int? year,
    String? color,
    String? licensePlate,
    String? vin,
    DateTime? createdAt,
  }) {
    return Car(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      color: color ?? this.color,
      licensePlate: licensePlate ?? this.licensePlate,
      vin: vin ?? this.vin,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
