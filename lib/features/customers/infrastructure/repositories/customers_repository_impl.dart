import 'package:sap_automotriz_app/features/customers/domain/entities/customer.dart';
import 'package:sap_automotriz_app/features/customers/domain/repositories/customers_repository.dart';
import 'package:sap_automotriz_app/features/customers/infrastructure/datasources/customers_datasource.dart';

class CustomersRepositoryImpl extends CustomersRepository {
  final CustomersDatasource _datasource;

  CustomersRepositoryImpl(this._datasource);

  @override
  Future<List<Customer>> getCustomers() {
    return _datasource.getCustomers();
  }

  @override
  Future<Customer> getCustomerById(int id) {
    return _datasource.getCustomerById(id);
  }

  @override
  Future<Customer> createCustomer(Customer customer) {
    return _datasource.createCustomer(customer);
  }

  @override
  Future<Customer> updateCustomer(Customer customer) {
    return _datasource.updateCustomer(customer);
  }

  @override
  Future<void> deleteCustomer(int id) {
    return _datasource.deleteCustomer(id);
  }
}
