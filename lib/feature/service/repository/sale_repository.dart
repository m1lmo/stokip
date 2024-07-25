import 'package:dio/dio.dart';
import 'package:stokip/feature/model/sales_model.dart';
import 'package:stokip/feature/service/i_repository.dart';

final class SaleRepository extends IRepository<SalesModel> {
  SaleRepository(this.dio);
  @override
  final Dio dio;
  @override
  String get path => '/account/sale';

  @override
  SalesModel Function(Map<String, dynamic> json) get fromJson => SalesModel.fromJson;
}
