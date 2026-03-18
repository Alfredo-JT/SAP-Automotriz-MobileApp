import 'package:sap_automotriz_app/features/services/domain/entities/service_with_quote_composite.dart';
import 'package:sap_automotriz_app/features/services/infrastructure/models/quote_model.dart';
import 'package:sap_automotriz_app/features/services/infrastructure/models/service_model.dart';

class ServiceWithQuoteModel extends ServiceWithQuote {
  const ServiceWithQuoteModel({required super.service, super.quote});

  factory ServiceWithQuoteModel.fromJson(Map<String, dynamic> json) {
    final quoteJson = json['quote'] as Map<String, dynamic>?;

    return ServiceWithQuoteModel(
      service: ServiceModel.fromJson(json),
      quote: quoteJson != null ? QuoteModel.fromJson(quoteJson) : null,
    );
  }
}
