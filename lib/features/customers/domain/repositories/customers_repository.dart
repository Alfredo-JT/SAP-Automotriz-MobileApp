import 'package:sap_automotriz_app/features/customers/domain/entities/customer.dart';

abstract class CustomersRepository {
  Future<List<Customer>> getCustomers();
  Future<Customer> getCustomerById(int id);
  Future<void> createCustomer(Customer customer);
  Future<void> updateCustomer(Customer customer);
  Future<void> deleteCustomer(int id);
}
