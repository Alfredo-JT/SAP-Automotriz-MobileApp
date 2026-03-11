import 'package:sap_automotriz_app/features/customers/domain/entities/customer.dart';
import 'package:sap_automotriz_app/features/customers/domain/repositories/customers_repository.dart';
import 'package:sap_automotriz_app/features/customers/infrastructure/datasources/customers_datasource.dart';

class CustomersRepositoryImpl extends CustomersRepository {
  final CustomersDatasource datasource;

  CustomersRepositoryImpl({required this.datasource});

  @override
  Future<List<Customer>> getCustomers() {
    return datasource.getCustomers();
  }

  @override
  Future<Customer> getCustomerById(int id) {
    return datasource.getCustomerById(id);
  }

  @override
  Future<void> createCustomer(Customer customer) {
    return datasource.createCustomer(customer);
  }

  @override
  Future<void> deleteCustomer(int id) {
    return datasource.deleteCustomer(id);
  }

  @override
  Future<void> updateCustomer(Customer customer) {
    return datasource.updateCustomer(customer);
  }
}
