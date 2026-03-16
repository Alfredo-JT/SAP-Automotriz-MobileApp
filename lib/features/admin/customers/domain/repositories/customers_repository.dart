import 'package:sap_automotriz_app/features/admin/customers/domain/entities/customer.dart';

abstract class CustomersRepository {
  Future<List<Customer>> getCustomers();
  Future<Customer> getCustomerById(int id);
  Future<Customer> createCustomer(Customer customer);
  Future<Customer> updateCustomer(Customer customer);
  Future<void> deleteCustomer(int id);
}
