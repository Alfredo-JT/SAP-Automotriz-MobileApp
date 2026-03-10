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
}

enum QuoteItemType {
  labor,
  sparePart,
  additionalExpense,
  externalService,
  other,
}

extension QuoteItemTypeExtension on QuoteItemType {
  String get value {
    switch (this) {
      case QuoteItemType.labor:
        return 'labor';
      case QuoteItemType.sparePart:
        return 'spare_part';
      case QuoteItemType.additionalExpense:
        return 'additional_expense';
      case QuoteItemType.externalService:
        return 'external_service';
      case QuoteItemType.other:
        return 'other';
    }
  }

  String get label {
    switch (this) {
      case QuoteItemType.labor:
        return 'Mano de obra';
      case QuoteItemType.sparePart:
        return 'Refacción';
      case QuoteItemType.additionalExpense:
        return 'Gasto adicional';
      case QuoteItemType.externalService:
        return 'Servicio externo';
      case QuoteItemType.other:
        return 'Otro';
    }
  }
}

class QuoteLineItem {
  final int? id;
  final int quoteId;
  final int? laborId;
  final String description;
  final QuoteItemType itemType;
  final int quantity;
  final double unitPrice;
  final double totalAmount;
  final bool taxable;
  final double? taxAmount;
  final String? unit;
  final String? evidenceUrl;
  final DateTime? createdAt;

  const QuoteLineItem({
    this.id,
    required this.quoteId,
    this.laborId,
    required this.description,
    required this.itemType,
    required this.quantity,
    required this.unitPrice,
    required this.totalAmount,
    required this.taxable,
    this.taxAmount,
    this.unit,
    this.evidenceUrl,
    this.createdAt,
  });

  QuoteLineItem copyWith({
    int? id,
    int? quoteId,
    int? laborId,
    String? description,
    QuoteItemType? itemType,
    int? quantity,
    double? unitPrice,
    double? totalAmount,
    bool? taxable,
    double? taxAmount,
    String? unit,
    String? evidenceUrl,
    DateTime? createdAt,
  }) {
    return QuoteLineItem(
      id: id ?? this.id,
      quoteId: quoteId ?? this.quoteId,
      laborId: laborId ?? this.laborId,
      description: description ?? this.description,
      itemType: itemType ?? this.itemType,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalAmount: totalAmount ?? this.totalAmount,
      taxable: taxable ?? this.taxable,
      taxAmount: taxAmount ?? this.taxAmount,
      unit: unit ?? this.unit,
      evidenceUrl: evidenceUrl ?? this.evidenceUrl,
      createdAt: createdAt ?? this.createdAt,
    );
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
