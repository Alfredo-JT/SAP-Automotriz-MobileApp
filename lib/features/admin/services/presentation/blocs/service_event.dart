import 'package:sap_automotriz_app/features/services/domain/entities/entities.dart';

abstract class ServicesEvent {}

class ServicesLoadRequested extends ServicesEvent {
  // final int serviceId;
  // ServicesLoadRequested(this.serviceId);
  ServicesLoadRequested();
}

class ServiceCreateRequested extends ServicesEvent {
  final Service service;
  ServiceCreateRequested(this.service);
}

class ServiceUpdateRequested extends ServicesEvent {
  final Service service;
  ServiceUpdateRequested(this.service);
}

class ServiceDeleteRequested extends ServicesEvent {
  final Service service;
  ServiceDeleteRequested(this.service);
}
