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

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: HiveTypes.salesModelId)
@immutable
final class SalesModel extends MainModel with EquatableMixin, HiveModel2Mixin {
  SalesModel({
   this.id,
    required this.dateTime,
    this.stockDetailModel,
    this.quantity,
    this.price,
    this.currency,
    this.itemName,
    this.customer,
  });

  factory SalesModel.fromJson(Map<String, dynamic> json) {
    return _$SalesModelFromJson(json);
  }
  @HiveField(0)
  @JsonKey(name: 'saleId')
  final int? id;
  @HiveField(1)
  @JsonKey(name: 'itemDetail')
  final StockDetailModel? stockDetailModel;
  @HiveField(2)
  @JsonKey(name: 'quantitySold')
  final double? quantity;
  @HiveField(3)
  @JsonKey(name: 'soldDate', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime dateTime;
  @HiveField(4)
  @JsonKey(name: 'salePrice')
  final double? price;
  @HiveField(5)
  @JsonKey(name: 'currencyType')
  final CurrencyEnum? currency;
  @HiveField(6)
  final CustomerModel? customer;
  @HiveField(7)
  final String? itemName;
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

  @override
  Map<String, dynamic> toJson() {
    return _$SalesModelToJson(this);
  }

  static DateTime _dateTimeFromJson(String date) {
    return DateTime.parse(date);
  }

  static String _dateTimeToJson(DateTime date) {
    return date.toUtc().toIso8601String();
  }

  SalesModel copyWith({
    int? id,
    ValueGetter<StockDetailModel?>? stockDetailModel,
    ValueGetter<double?>? quantity,
    DateTime? dateTime,
    ValueGetter<double?>? price,
    ValueGetter<CurrencyEnum?>? currency,
    ValueGetter<CustomerModel?>? customer,
    ValueGetter<String?>? itemName,
  }) {
    return SalesModel(
      id: id ?? this.id,
      stockDetailModel: stockDetailModel != null ? stockDetailModel() : this.stockDetailModel,
      quantity: quantity != null ? quantity() : this.quantity,
      dateTime: dateTime ?? this.dateTime,
      price: price != null ? price() : this.price,
      currency: currency != null ? currency() : this.currency,
      customer: customer != null ? customer() : this.customer,
      itemName: itemName != null ? itemName() : this.itemName,
    );
  }
}
