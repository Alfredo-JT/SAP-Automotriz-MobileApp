import 'package:sap_automotriz_app/features/services/domain/entities/quote_line_item.dart';

class QuoteLineItemModel extends QuoteLineItem {
  const QuoteLineItemModel({
    super.id,
    required super.quoteId,
    super.laborId,
    super.sparePartId,
    required super.description,
    required super.itemType,
    super.quantity,
    super.unitPrice,
    super.totalAmount,
    required super.taxable,
    super.taxAmount,
    super.unit,
    super.evidenceUrl,
    super.createdAt,
    super.updatedAt,
  });

  factory QuoteLineItemModel.fromJson(Map<String, dynamic> json) {
    return QuoteLineItemModel(
      id: json['id'] as int?,
      quoteId: json['quote_id'] as int,
      laborId: json['labor_id'] as int?,
      sparePartId: json['spare_part_id'] as int?,
      description: json['description'] as String,
      itemType: QuoteItemTypeExtension.fromString(json['item_type'] as String),
      quantity: json['quantity'] as int?,
      unitPrice: json['unit_price'] != null
          ? (json['unit_price'] as num).toDouble()
          : null,
      totalAmount: json['total_amount'] != null
          ? (json['total_amount'] as num).toDouble()
          : null,
      taxable: json['taxable'] as bool,
      taxAmount: json['tax_amount'] != null
          ? (json['tax_amount'] as num).toDouble()
          : null,
      unit: json['unit'] as String?,
      evidenceUrl: json['evidence_url'] as String?,
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
      'quote_id': quoteId,
      if (laborId != null) 'labor_id': laborId,
      if (sparePartId != null) 'spare_part_id': sparePartId,
      'description': description,
      'item_type': itemType.value,
      if (quantity != null) 'quantity': quantity,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (totalAmount != null) 'total_amount': totalAmount,
      'taxable': taxable,
      if (taxAmount != null) 'tax_amount': taxAmount,
      if (unit != null) 'unit': unit,
      if (evidenceUrl != null) 'evidence_url': evidenceUrl,
    };
  }

  factory QuoteLineItemModel.fromEntity(QuoteLineItem item) {
    return QuoteLineItemModel(
      id: item.id,
      quoteId: item.quoteId,
      laborId: item.laborId,
      sparePartId: item.sparePartId,
      description: item.description,
      itemType: item.itemType,
      quantity: item.quantity,
      unitPrice: item.unitPrice,
      totalAmount: item.totalAmount,
      taxable: item.taxable,
      taxAmount: item.taxAmount,
      unit: item.unit,
      evidenceUrl: item.evidenceUrl,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
    );
  }
}
