// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stokip/product/database/core/hive_types.dart';
import 'package:stokip/product/database/core/model/hive_model2_mixin.dart';

part 'stock_model.g.dart';

// enum Models { StockModel, StockDetailModel, ImporterModel }

// abstract class MainModel<T extends Models> {
abstract class MainModel {
  final String? title;

  MainModel({
    this.title,
  });
}

@JsonSerializable()
@HiveType(typeId: HiveTypes.stockModelId)
class StockModel extends MainModel with HiveModel2Mixin {
  @override
  String get key {
    return id.toString();
  }

  @HiveField(0)
  final int id;
  @HiveField(1)
  final double? pPrice;
  @HiveField(2)
  final double? sPrice;
  @HiveField(3)
  @override
  final String? title;
  @HiveField(4)
  final List<StockDetailModel> stockDetailModel;
  @HiveField(5)
  double? totalMeter;
  @HiveField(6)
  DateTime? purchaseDate;

  StockModel({this.id = 0, this.title, this.pPrice, this.sPrice, this.stockDetailModel = const [], this.totalMeter, this.purchaseDate});
  factory StockModel.fromJson(Map<String, dynamic> json) {
    return _$StockModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StockModelToJson(this);
  }
}

@JsonSerializable()
@HiveType(typeId: HiveTypes.stockDetailModelId)
class StockDetailModel extends MainModel {
  @override
  @HiveField(0)
  final String? title;
  @HiveField(1)
  double? meter;
  StockDetailModel({
    this.title,
    this.meter,
  });
  factory StockDetailModel.fromJson(Map<String, dynamic> json) {
    return _$StockDetailModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StockDetailModelToJson(this);
  }
}
