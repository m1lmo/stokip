import 'package:dio/src/dio.dart';
import 'package:stokip/feature/model/importer_model.dart';
import 'package:stokip/feature/service/i_repository.dart';

final class ImporterRepository extends IRepository<ImporterModel> {
  ImporterRepository(this.dio);

  @override
  late final Dio dio;

  @override
  ImporterModel Function(Map<String, dynamic> json) get fromJson => ImporterModel.fromJson;

  @override
  String get path => '/account/supplier';
}
