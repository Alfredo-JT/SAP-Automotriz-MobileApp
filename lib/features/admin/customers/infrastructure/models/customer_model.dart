import 'package:sap_automotriz_app/features/admin/customers/domain/entities/customer.dart';

class CustomerModel extends Customer {
  const CustomerModel({
    super.id,
    required super.fullName,
    required super.phone,
    super.email,
    super.rfc,
    super.createdAt,
    super.updatedAt,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as int?,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      rfc: json['rfc'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'full_name': fullName,
      'phone': phone,
      if (email != null) 'email': email,
      if (rfc != null) 'rfc': rfc,
    };
  }

  factory CustomerModel.fromEntity(Customer customer) {
    return CustomerModel(
      id: customer.id,
      fullName: customer.fullName,
      phone: customer.phone,
      email: customer.email,
      rfc: customer.rfc,
      createdAt: customer.createdAt,
      updatedAt: customer.updatedAt,
    );
  }
}
