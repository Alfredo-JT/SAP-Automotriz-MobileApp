import 'package:sap_automotriz_app/features/users/domain/entities/user.dart';

class UserAccountModel extends UserAccount {
  const UserAccountModel({
    super.id,
    required super.fullName,
    required super.phone,
    super.email,
    super.password,
    super.salary,
    required super.role,
    required super.isActive,
    super.createdAt,
    super.updatedAt,
  });

  factory UserAccountModel.fromJson(Map<String, dynamic> json) {
    return UserAccountModel(
      id: json['id'] as int?,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      role: UserRoleExtension.fromString(json['role'] as String),
      password: json['password'] as String?,
      salary: json['salary'] != null
          ? (json['salary'] as num).toDouble()
          : null,
      isActive: json['is_active'] as bool,
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
      'role': role.value,
      'is_active': isActive,
    };
  }

  factory UserAccountModel.fromEntity(UserAccount customer) {
    return UserAccountModel(
      id: customer.id,
      fullName: customer.fullName,
      phone: customer.phone,
      email: customer.email,
      role: customer.role,
      isActive: customer.isActive,
      password: customer.password,
      salary: customer.salary,
      createdAt: customer.createdAt,
      updatedAt: customer.updatedAt,
    );
  }
}
