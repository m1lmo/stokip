import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stokip/feature/model/customer_model.dart';
import 'package:stokip/feature/service/repository/customer_repository.dart';

void main() {
  late final CustomerRepository customerRepository;
  late final Dio dio;

  setUp(() {
    dio = Dio();
    customerRepository = CustomerRepository(dio);
    dio.options = BaseOptions(
      baseUrl: customerRepository.baseUrl,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbF9hZGRyZXNzIjoidGVzdDJAZ21haWwuY29tIiwiZmlyc3RfbmFtZSI6Im9tZXIiLCJpZCI6MSwibGFzdF9uYW1lIjoiS29jYSJ9.FJyrHJvqiacSzUI4NAxzkbCxf-yNL15EysXB0r8APUc',
      },
    );
  });
  test(
    'customer route should be account/customer ',
    () {
      // This test will pass.
      expect(customerRepository.path, '/account/customer');
      expect(customerRepository.baseUrl, 'http://localhost:8080');
    },
  );
  test('CustomerRepository post data', () async {
    final post = await customerRepository.postData(
      CustomerModel(id: 0, title: 'Ömer23'),
    );
    print(post);
    expect(post, true);
  });
  test('CustomerRepository get data', () async {
    final get = await customerRepository.fetchData();
    print(get);
    expect(get, isA<List<CustomerModel>>());
  });
}
