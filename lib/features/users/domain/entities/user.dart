import 'dart:ui';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';

enum UserRole { admin, technician, workshopManager }

extension UserRoleExtension on UserRole {
  String get value {
    switch (this) {
      case UserRole.admin:
        return 'admin';
      case UserRole.technician:
        return 'technician';
      case UserRole.workshopManager:
        return 'workshop_manager';
    }
  }

  String get label {
    switch (this) {
      case UserRole.admin:
        return 'Administrador';
      case UserRole.technician:
        return 'Técnico';
      case UserRole.workshopManager:
        return 'Jefe de taller';
    }
  }

  static UserRole fromString(String value) {
    switch (value) {
      case 'admin':
        return UserRole.admin;
      case 'technician':
        return UserRole.technician;
      case 'workshop_manager':
        return UserRole.workshopManager;
      default:
        throw ArgumentError('Unknown role: $value');
    }
  }
}

extension UserRoleColor on UserRole {
  Color get color {
    switch (this) {
      case UserRole.admin:
        return AppColors.crimsonRed;
      case UserRole.technician:
        return const Color(0xFF2563EB);
      case UserRole.workshopManager:
        return AppColors.golden;
    }
  }
}

class UserAccount {
  final int? id;
  final String fullName;
  final String phone;
  final String? email;
  final UserRole role;
  final String? password;
  final double? salary;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserAccount({
    this.id,
    required this.fullName,
    required this.phone,
    this.email,
    required this.role,
    this.password,
    this.salary,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  UserAccount copyWith({
    int? id,
    String? fullName,
    String? phone,
    String? email,
    UserRole? role,
    String? password,
    double? salary,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserAccount(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      role: role ?? this.role,
      password: password ?? this.password,
      salary: salary ?? this.salary,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
