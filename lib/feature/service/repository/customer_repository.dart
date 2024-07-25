import 'package:dio/src/dio.dart';
import 'package:stokip/feature/model/customer_model.dart';
import 'package:stokip/feature/service/i_repository.dart';

final class CustomerRepository extends IRepository<CustomerModel> {
  CustomerRepository(this.dio);
  @override
  late final Dio dio;

  @override
  CustomerModel Function(Map<String, dynamic> json) get fromJson => CustomerModel.fromJson;

  @override
  String get path => '/account/customer';
}
