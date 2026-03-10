import 'package:sap_automotriz_app/features/customers/domain/entities/car.dart';
import 'package:sap_automotriz_app/features/customers/domain/entities/customer.dart';

enum ServiceStatus {
  notStarted,
  underReview,
  quoted,
  authorized,
  inProgress,
  completed,
  delivered,
  cancelled,
  notAuthorized,
}

extension ServiceStatusExtension on ServiceStatus {
  String get value {
    switch (this) {
      case ServiceStatus.notStarted:
        return 'not_started';
      case ServiceStatus.underReview:
        return 'under_review';
      case ServiceStatus.quoted:
        return 'quoted';
      case ServiceStatus.authorized:
        return 'authorized';
      case ServiceStatus.inProgress:
        return 'in_progress';
      case ServiceStatus.completed:
        return 'completed';
      case ServiceStatus.delivered:
        return 'delivered';
      case ServiceStatus.cancelled:
        return 'cancelled';
      case ServiceStatus.notAuthorized:
        return 'not_authorized';
    }
  }

  String get label {
    switch (this) {
      case ServiceStatus.notStarted:
        return 'Sin iniciar';
      case ServiceStatus.underReview:
        return 'En revisión';
      case ServiceStatus.quoted:
        return 'Cotizado';
      case ServiceStatus.authorized:
        return 'Autorizado';
      case ServiceStatus.inProgress:
        return 'En proceso';
      case ServiceStatus.completed:
        return 'Completado';
      case ServiceStatus.delivered:
        return 'Entregado';
      case ServiceStatus.cancelled:
        return 'Cancelado';
      case ServiceStatus.notAuthorized:
        return 'No autorizado';
    }
  }

  static ServiceStatus fromString(String v) {
    return ServiceStatus.values.firstWhere(
      (e) => e.value == v,
      orElse: () => ServiceStatus.notStarted,
    );
  }
}

enum ServiceChannel { inPerson, phoneCall, whatsapp }

extension ServiceChannelExtension on ServiceChannel {
  String get value {
    switch (this) {
      case ServiceChannel.inPerson:
        return 'in_person';
      case ServiceChannel.phoneCall:
        return 'phone_call';
      case ServiceChannel.whatsapp:
        return 'whatsapp';
    }
  }

  String get label {
    switch (this) {
      case ServiceChannel.inPerson:
        return 'Presencial';
      case ServiceChannel.phoneCall:
        return 'Llamada';
      case ServiceChannel.whatsapp:
        return 'WhatsApp';
    }
  }
}

enum ServiceType { general, alignmentBalancing }

extension ServiceTypeExtension on ServiceType {
  String get value {
    switch (this) {
      case ServiceType.general:
        return 'general';
      case ServiceType.alignmentBalancing:
        return 'alignment_balancing';
    }
  }

  String get label {
    switch (this) {
      case ServiceType.general:
        return 'General';
      case ServiceType.alignmentBalancing:
        return 'Alineación y Balanceo';
    }
  }
}

class Service {
  final int? id;
  final int customerId;
  final int carId;
  final int createdByUserId;
  final String folio;
  final ServiceChannel channel;
  final String shortDescription;
  final String? detailedDescription;
  final ServiceStatus status;
  final DateTime intakeDate;
  final DateTime? estimatedDeliveryDate;
  final DateTime? actualDeliveryDate;
  final ServiceType serviceType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Populated joins (for display)
  final Customer? customer;
  final Car? car;

  const Service({
    this.id,
    required this.customerId,
    required this.carId,
    required this.createdByUserId,
    required this.folio,
    required this.channel,
    required this.shortDescription,
    this.detailedDescription,
    required this.status,
    required this.intakeDate,
    this.estimatedDeliveryDate,
    this.actualDeliveryDate,
    required this.serviceType,
    this.createdAt,
    this.updatedAt,
    this.customer,
    this.car,
  });

  Service copyWith({
    int? id,
    int? customerId,
    int? carId,
    int? createdByUserId,
    String? folio,
    ServiceChannel? channel,
    String? shortDescription,
    String? detailedDescription,
    ServiceStatus? status,
    DateTime? intakeDate,
    DateTime? estimatedDeliveryDate,
    DateTime? actualDeliveryDate,
    ServiceType? serviceType,
    DateTime? createdAt,
    DateTime? updatedAt,
    Customer? customer,
    Car? car,
  }) {
    return Service(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      carId: carId ?? this.carId,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      folio: folio ?? this.folio,
      channel: channel ?? this.channel,
      shortDescription: shortDescription ?? this.shortDescription,
      detailedDescription: detailedDescription ?? this.detailedDescription,
      status: status ?? this.status,
      intakeDate: intakeDate ?? this.intakeDate,
      estimatedDeliveryDate:
          estimatedDeliveryDate ?? this.estimatedDeliveryDate,
      actualDeliveryDate: actualDeliveryDate ?? this.actualDeliveryDate,
      serviceType: serviceType ?? this.serviceType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      customer: customer ?? this.customer,
      car: car ?? this.car,
    );
  }
}
