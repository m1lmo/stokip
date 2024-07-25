import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stokip/feature/model/customer_model.dart';
import 'package:stokip/feature/model/sales_model.dart';
import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/feature/service/repository/sale_repository.dart';

void main() {
  late final Dio dio;
  late final SaleRepository saleRepository;
  setUp(() {
    dio = Dio();
    saleRepository = SaleRepository(dio);
    dio.options = BaseOptions(
      baseUrl: saleRepository.baseUrl,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbF9hZGRyZXNzIjoidGVzdDJAZ21haWwuY29tIiwiZmlyc3RfbmFtZSI6Im9tZXIiLCJpZCI6MSwibGFzdF9uYW1lIjoiS29jYSJ9.FJyrHJvqiacSzUI4NAxzkbCxf-yNL15EysXB0r8APUc',
      },
    );
  });
  test('sale dio base url', () {
    expect(saleRepository.baseUrl, 'http://localhost:8080');
  });
  test('sale path', () {
    expect(saleRepository.path, '/account/sale');
  });
  test('post sale', () async {
    final saleModel = SalesModel(
      itemName: 'flutter2',
      price: 10,
      quantity: 22,
      id: 1,

      dateTime: DateTime.now(),
      customer: CustomerModel(id: 1, title: 'müsteri'),
      stockDetailModel: StockDetailModel(
        itemDetailId: 0,
        itemId: 0,
        title: 'test',
      ),
    );
    print(saleModel.toJson());
    final b = await saleRepository.postData(saleModel);
    log(b.toString());
    // expect(saleRepository.postData(saleModel), isA<Future<bool>>());
  });

  test('get sale', () async {
    final data = await saleRepository.fetchData();
    print(data);
    expect(data, isA<List<SalesModel>>());
  });
}
