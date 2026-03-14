import 'package:sap_automotriz_app/features/services/domain/entities/quote.dart';
import 'package:sap_automotriz_app/features/services/domain/entities/service.dart';

/// Entidad compuesta que representa lo que el backend devuelve
class ServiceWithQuote {
  final Service service;
  final Quote? quote;

  const ServiceWithQuote({required this.service, this.quote});

  ServiceWithQuote copyWith({Service? service, Quote? quote}) {
    return ServiceWithQuote(
      service: service ?? this.service,
      quote: quote ?? this.quote,
    );
  }
}
