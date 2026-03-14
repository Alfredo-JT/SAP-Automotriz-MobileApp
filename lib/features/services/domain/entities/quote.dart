import 'package:sap_automotriz_app/features/services/domain/entities/entities.dart';

enum QuoteStatus { draft, sent, authorized, rejected, cancelled }

extension QuoteStatusExtension on QuoteStatus {
  String get value {
    switch (this) {
      case QuoteStatus.draft:
        return 'draft';
      case QuoteStatus.sent:
        return 'sent';
      case QuoteStatus.authorized:
        return 'authorized';
      case QuoteStatus.rejected:
        return 'rejected';
      case QuoteStatus.cancelled:
        return 'cancelled';
    }
  }

  String get label {
    switch (this) {
      case QuoteStatus.draft:
        return 'Borrador';
      case QuoteStatus.sent:
        return 'Enviado';
      case QuoteStatus.authorized:
        return 'Autorizado';
      case QuoteStatus.rejected:
        return 'Rechazado';
      case QuoteStatus.cancelled:
        return 'Cancelado';
    }
  }

  static QuoteStatus fromString(String value) {
    switch (value) {
      case 'draft':
        return QuoteStatus.draft;
      case 'sent':
        return QuoteStatus.sent;
      case 'authorized':
        return QuoteStatus.authorized;
      case 'rejected':
        return QuoteStatus.rejected;
      case 'cancelled':
        return QuoteStatus.cancelled;
      default:
        throw ArgumentError('Unknown quote status: $value');
    }
  }
}

class Quote {
  final int? id;
  final int serviceId;
  final QuoteStatus status;
  final double? subtotal;
  final double? total;
  final int version;
  final List<QuoteLineItem> lineItems;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Quote({
    this.id,
    required this.serviceId,
    required this.status,
    this.subtotal,
    this.total,
    required this.version,
    this.lineItems = const [],
    this.createdAt,
    this.updatedAt,
  });

  Quote copyWith({
    int? id,
    int? serviceId,
    QuoteStatus? status,
    double? subtotal,
    double? total,
    int? version,
    List<QuoteLineItem>? lineItems,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Quote(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      total: total ?? this.total,
      version: version ?? this.version,
      lineItems: lineItems ?? this.lineItems,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
