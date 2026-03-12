import 'package:sap_automotriz_app/features/customers/domain/entities/customer.dart';

abstract class CustomersEvent {}

class CustomersLoadRequested extends CustomersEvent {}

class CustomerCreateRequested extends CustomersEvent {
  final Customer customer;
  CustomerCreateRequested(this.customer);
}

class CustomerUpdateRequested extends CustomersEvent {
  final Customer customer;
  CustomerUpdateRequested(this.customer);
}

class CustomerDeleteRequested extends CustomersEvent {
  final int id;
  CustomerDeleteRequested(this.id);
}
