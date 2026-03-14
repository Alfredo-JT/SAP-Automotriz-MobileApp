import 'package:sap_automotriz_app/features/services/domain/entities/quote.dart';
import 'package:sap_automotriz_app/features/services/infrastructure/models/quote_line_item_model.dart';

class QuoteModel extends Quote {
  const QuoteModel({
    super.id,
    required super.serviceId,
    required super.status,
    super.subtotal,
    super.total,
    required super.version,
    super.lineItems = const [],
    super.createdAt,
    super.updatedAt,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['line_items'] as List<dynamic>? ?? [];
    final lineItems = rawItems
        .map(
          (item) => QuoteLineItemModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();

    return QuoteModel(
      id: json['id'] as int?,
      serviceId: json['service_id'] as int,
      status: QuoteStatusExtension.fromString(json['status'] as String),
      subtotal: json['subtotal'] != null
          ? (json['subtotal'] as num).toDouble()
          : null,
      total: json['total'] != null ? (json['total'] as num).toDouble() : null,
      version: json['version'] as int,
      lineItems: lineItems,
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
      'service_id': serviceId,
      'status': status.value,
      if (subtotal != null) 'subtotal': subtotal,
      if (total != null) 'total': total,
      'version': version,
    };
  }

  factory QuoteModel.fromEntity(Quote quote) {
    return QuoteModel(
      id: quote.id,
      serviceId: quote.serviceId,
      status: quote.status,
      subtotal: quote.subtotal,
      total: quote.total,
      version: quote.version,
      lineItems: quote.lineItems,
      createdAt: quote.createdAt,
      updatedAt: quote.updatedAt,
    );
  }
}
