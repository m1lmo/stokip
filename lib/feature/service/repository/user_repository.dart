import 'package:dio/src/dio.dart';
import 'package:stokip/feature/model/user_model.dart';
import 'package:stokip/feature/service/i_repository.dart';

final class UserRepository extends IRepository<UserModel> {
  UserRepository(this.dio);
  @override
  late final Dio dio;
  @override
  UserModel Function(Map<String, dynamic> json) get fromJson => UserModel.fromJson;

  @override
  String get path => '/login';
}
