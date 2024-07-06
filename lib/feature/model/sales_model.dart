// ignore_for_file: public_member_api_docs,

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stokip/feature/model/customer_model.dart';
import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/product/constants/enums/currency_enum.dart';
import 'package:stokip/product/database/core/hive_types.dart';
import 'package:stokip/product/database/core/model/hive_model2_mixin.dart';

part 'sales_model.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveTypes.salesModelId)
@immutable
final class SalesModel extends MainModel with EquatableMixin, HiveModel2Mixin {
  SalesModel({
    required this.id,
    required this.dateTime,
    this.stockDetailModel,
    this.quantity,
    this.price,
    this.currency,
    this.customer,
  });

  factory SalesModel.fromJson(Map<String, dynamic> json) {
    return _$SalesModelFromJson(json);
  }
  @HiveField(0)
  final int id;
  @HiveField(1)
  final StockDetailModel? stockDetailModel;
  @HiveField(2)
  final double? quantity;
  @HiveField(3)
  final DateTime dateTime;
  @HiveField(4)
  final double? price;
  @HiveField(5)
  final CurrencyEnum? currency;
  @HiveField(6)
  final CustomerModel? customer;
  @override
  String? get title => stockDetailModel?.title;
  @override
  List<Object?> get props => [
        id,
        dateTime,
        stockDetailModel,
        quantity,
        price,
        currency,
        customer,
      ]; 

  @override
  String get key => id.toString();

  Map<String, dynamic> toJson() {
    return _$SalesModelToJson(this);
  }
}
  