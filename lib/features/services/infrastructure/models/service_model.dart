import 'package:sap_automotriz_app/features/services/domain/entities/service.dart';

class ServiceModel extends Service {
  const ServiceModel({
    super.id,
    required super.customerId,
    required super.carId,
    required super.createdByUserId,
    required super.folio,
    required super.channel,
    required super.shortDescription,
    super.detailedDescription,
    required super.status,
    required super.intakeDate,
    super.estimatedDeliveryDate,
    super.actualDeliveryDate,
    super.sharepointFilePath,
    required super.serviceType,
    super.createdAt,
    super.updatedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as int?,
      customerId: json['customer_id'] as int,
      carId: json['car_id'] as int,
      createdByUserId: json['created_by_user_id'] as int,
      folio: json['folio'] as String,
      channel: ServiceChannelExtension.fromString(json['channel'] as String),
      shortDescription: json['short_description'] as String,
      detailedDescription: json['detailed_description'] as String?,
      status: ServiceStatusExtension.fromString(json['status'] as String),
      intakeDate: DateTime.parse(json['intake_date'] as String),
      estimatedDeliveryDate: json['estimated_delivery_date'] != null
          ? DateTime.parse(json['estimated_delivery_date'] as String)
          : null,
      actualDeliveryDate: json['actual_delivery_date'] != null
          ? DateTime.parse(json['actual_delivery_date'] as String)
          : null,
      sharepointFilePath: json['sharepoint_file_path'] as String?,
      serviceType: ServiceTypeExtension.fromString(
        json['service_type'] as String,
      ),
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
      'customer_id': customerId,
      'car_id': carId,
      'created_by_user_id': createdByUserId,
      'folio': folio,
      'channel': channel.value,
      'short_description': shortDescription,
      if (detailedDescription != null)
        'detailed_description': detailedDescription,
      'status': status.value,
      'intake_date': intakeDate.toIso8601String(),
      if (estimatedDeliveryDate != null)
        'estimated_delivery_date': estimatedDeliveryDate!.toIso8601String(),
      if (actualDeliveryDate != null)
        'actual_delivery_date': actualDeliveryDate!.toIso8601String(),
      if (sharepointFilePath != null)
        'sharepoint_file_path': sharepointFilePath,
      'service_type': serviceType.value,
    };
  }

  factory ServiceModel.fromEntity(Service service) {
    return ServiceModel(
      id: service.id,
      customerId: service.customerId,
      carId: service.carId,
      createdByUserId: service.createdByUserId,
      folio: service.folio,
      channel: service.channel,
      shortDescription: service.shortDescription,
      detailedDescription: service.detailedDescription,
      status: service.status,
      intakeDate: service.intakeDate,
      estimatedDeliveryDate: service.estimatedDeliveryDate,
      actualDeliveryDate: service.actualDeliveryDate,
      sharepointFilePath: service.sharepointFilePath,
      serviceType: service.serviceType,
      createdAt: service.createdAt,
      updatedAt: service.updatedAt,
    );
  }
}
