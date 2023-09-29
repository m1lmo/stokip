// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/product/constants/enums/currency_enum.dart';
import 'package:stokip/product/database/core/hive_types.dart';
import 'package:stokip/product/database/core/model/hive_model2_mixin.dart';

part 'sales_model.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveTypes.salesModelId)
@immutable
final class SalesModel extends MainModel with EquatableMixin, HiveModel2Mixin {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String? title;
  @HiveField(2)
  final double? meter;
  @HiveField(3)
  final DateTime dateTime;
  @HiveField(4)
  final double? price;
  @HiveField(5)
  final CurrencyEnum? currency;

  SalesModel({
    required this.id,
    required this.dateTime,
    this.title,
    this.meter,
    this.price,
    this.currency,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [title, meter, dateTime, price];

  @override
  String get key => id.toString();
}
