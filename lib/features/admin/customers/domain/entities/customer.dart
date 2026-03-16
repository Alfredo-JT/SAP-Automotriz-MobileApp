class Customer {
  final int? id;
  final String fullName;
  final String phone;
  final String? email;
  final String? rfc;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Customer({
    this.id,
    required this.fullName,
    required this.phone,
    this.email,
    this.rfc,
    this.createdAt,
    this.updatedAt,
  });

  Customer copyWith({
    int? id,
    String? fullName,
    String? phone,
    String? email,
    String? rfc,
    DateTime? createdAt,
  }) {
    return Customer(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      rfc: rfc ?? this.rfc,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
