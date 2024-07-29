import 'package:flutter_test/flutter_test.dart';
import 'package:stokip/feature/model/user_model.dart';
import 'package:stokip/feature/service/repository/user_repository.dart';
import 'package:stokip/product/helper/dio_helper.dart';

void main() {
  late final UserRepository userRepository;
  late final DioHelper dioHelper;
  setUp(() {
    dioHelper = DioHelper.instance();
    userRepository = UserRepository(dioHelper.dio);
    dioHelper.setToken(
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbF9hZGRyZXNzIjoidGVzdDJAZ21haWwuY29tIiwiZmlyc3RfbmFtZSI6Im9tZXIiLCJpZCI6MSwibGFzdF9uYW1lIjoiS29jYSJ9.FJyrHJvqiacSzUI4NAxzkbCxf-yNL15EysXB0r8APUc',
    );
  });
  test('UserRepository should have a path', () {
    expect(userRepository.path, '/login');
  });
  test('UserRepository should have a base url', () {
    expect(userRepository.dio.options.baseUrl, 'http://localhost:8080');
  });
  test('user login', () async {
    final user = UserModel(email: 'test2@gmail.com', password: '123456');
    final response = await userRepository.postWithResponse(user);
    expect(response, isA<UserModel?>());
  });
}
