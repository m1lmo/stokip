// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stokip/feature/model/importer_model.dart';

import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/product/database/core/hive_types.dart';

part 'purchases_model.g.dart';

@HiveType(typeId: HiveTypes.purchasesModelId)
@JsonSerializable(explicitToJson: true)
final class PurchasesModel extends MainModel {
  @HiveField(1)
  final int id;
  @HiveField(2)
  final ImporterModel? supplier;
  @override
  @HiveField(3)
  final String? title;
  @HiveField(4)
  final String? detailTitle;
  @HiveField(5)
  final DateTime purchasedDate;
  @HiveField(6)
  final double? totalAmount;
  @HiveField(7)
  final double? meter;
  PurchasesModel({
    required this.purchasedDate,
    this.id = 0,
    this.supplier,
    this.title,
    this.detailTitle,
    this.totalAmount,
    this.meter,
  });

  @override
  String get key => id.toString();

  @override
  List<Object?> get props => [id, supplier, title, detailTitle, purchasedDate, totalAmount, meter];
  factory PurchasesModel.fromJson(Map<String, dynamic> json) {
    return _$PurchasesModelFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$PurchasesModelToJson(this);
  }
}
