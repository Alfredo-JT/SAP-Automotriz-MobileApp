class LaborCatalog {
  final int? id;
  final String name;
  final double standardHours;
  final double basePrice;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const LaborCatalog({
    this.id,
    required this.name,
    required this.standardHours,
    required this.basePrice,
    this.createdAt,
    this.updatedAt,
  });

  LaborCatalog copyWith({
    int? id,
    String? name,
    double? standardHours,
    double? basePrice,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LaborCatalog(
      id: id ?? this.id,
      name: name ?? this.name,
      standardHours: standardHours ?? this.standardHours,
      basePrice: basePrice ?? this.basePrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
