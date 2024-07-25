import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/feature/service/repository/stock_repository.dart';

void main() {
  late final StockRepository stockRepository;
  late final Dio dio;
  setUp(() {
    dio = Dio();
    stockRepository = StockRepository(dio);
    dio.options = BaseOptions(
      baseUrl: stockRepository.baseUrl,
      headers: {
        // 'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbF9hZGRyZXNzIjoidGVzdDJAZ21haWwuY29tIiwiZmlyc3RfbmFtZSI6Im9tZXIiLCJpZCI6MSwibGFzdF9uYW1lIjoiS29jYSJ9.FJyrHJvqiacSzUI4NAxzkbCxf-yNL15EysXB0r8APUc',
      },
    );
  });
  test('StockRepository should have a path', () {
    expect(stockRepository.path, '/account/stocks');
  });
  test('StockRepository should have a base url', () {
    expect(stockRepository.dio.options.baseUrl, 'http://localhost:8080');
  });
  test('StockRepository should have a dio', () {
    expect(stockRepository.dio, dio);
  });
  test('StockRepository should have a fromJson function', () {
    expect(stockRepository.fromJson, isNotNull);
  });
  test('StockRepository should have a baseUrl', () {
    expect(stockRepository.dio.options, dio.options);
  });
  test('StockRepository should have a fetchData', () async {
    final data = await stockRepository.fetchData();
    print(data);
    // expect(stockRepository.fetchData(), isA<Future<List<StockModel?>?>>());
  });
  test('stock repository get data', () async {
    final data = await stockRepository.fetchData();
    print(data);
    expect(data, isA<List<StockModel>>());
  });
  test('StockRepository post data', () async {
    final stockDetailModel = StockDetailModel(
      itemDetailId: 0,
      itemId: 0,
      title: 'test',
      meter: 12,
    );
    final stockModel = StockModel(
      stockDetailModel: [stockDetailModel],
      id: 1,
      title: 'flutter2',
    );
    final b = await stockRepository.postData(stockModel);
    print(b);
    expect(stockRepository.postData(stockModel), isA<Future<bool>>());
  });
}
