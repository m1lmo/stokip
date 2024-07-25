import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stokip/feature/model/importer_model.dart';
import 'package:stokip/feature/service/repository/importer_repository.dart';

void main() {
  late final ImporterRepository importerRepository;
  late final Dio dio;
  setUp(() {
    dio = Dio();
    importerRepository = ImporterRepository(dio);
    dio.options = BaseOptions(
      baseUrl: importerRepository.baseUrl,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbF9hZGRyZXNzIjoidGVzdDJAZ21haWwuY29tIiwiZmlyc3RfbmFtZSI6Im9tZXIiLCJpZCI6MSwibGFzdF9uYW1lIjoiS29jYSJ9.FJyrHJvqiacSzUI4NAxzkbCxf-yNL15EysXB0r8APUc',
      },
    );
  });
  test('ImporterRepository should have a path', () {
    expect(importerRepository.path, '/account/supplier');
  });
  test('ImporterRepository should have a base url', () {
    expect(importerRepository.dio.options.baseUrl, 'http://localhost:8080');
  });
  test('ImporterRepository should have a dio', () {
    expect(importerRepository.dio, dio);
  });
  test('ImporterRepository post method should return a future', () async {
    final post = importerRepository.postData(
      ImporterModel(
        id: 0,
        title: 'Ömer3',
      ),
    );
    print(post);
    expect(
      post,
      isA<Future<bool>>(),
    );
  });
}
