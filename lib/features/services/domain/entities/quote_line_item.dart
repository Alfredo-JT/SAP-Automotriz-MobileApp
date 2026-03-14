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

  static QuoteItemType fromString(String value) {
    return QuoteItemType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown item type: $value'),
    );
  }
}

class QuoteLineItem {
  final int? id;
  final int quoteId;
  final int? laborId;
  final int? sparePartId;
  final String description;
  final QuoteItemType itemType;
  final int? quantity;
  final double? unitPrice;
  final double? totalAmount;
  final bool taxable;
  final double? taxAmount;
  final String? unit;
  final String? evidenceUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const QuoteLineItem({
    this.id,
    required this.quoteId,
    this.laborId,
    this.sparePartId,
    required this.description,
    required this.itemType,
    this.quantity,
    this.unitPrice,
    this.totalAmount,
    required this.taxable,
    this.taxAmount,
    this.unit,
    this.evidenceUrl,
    this.createdAt,
    this.updatedAt,
  });

  QuoteLineItem copyWith({
    int? id,
    int? quoteId,
    int? laborId,
    int? sparePartId,
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
    DateTime? updatedAt,
  }) {
    return QuoteLineItem(
      id: id ?? this.id,
      quoteId: quoteId ?? this.quoteId,
      laborId: laborId ?? this.laborId,
      sparePartId: sparePartId ?? this.sparePartId,
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
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
