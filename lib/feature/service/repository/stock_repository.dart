import 'package:dio/src/dio.dart';
import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/feature/service/i_repository.dart';

final class StockRepository extends IRepository<StockModel> {
  StockRepository(this.dio);
  @override
  final Dio dio;
  @override
  String get path => '/account/stocks';

  @override
  StockModel Function(Map<String, dynamic> json) get fromJson => StockModel.fromJson;
}
