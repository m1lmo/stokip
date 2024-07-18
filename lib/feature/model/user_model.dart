import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stokip/feature/model/stock_model.dart';
import 'package:stokip/product/database/core/hive_types.dart';

part 'user_model.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveTypes.userModelId)
final class UserModel extends MainModel {
  UserModel({
    this.jwtToken,
    this.name,
    this.email,
    this.password,
    this.phone,
    this.id,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return _$UserModelFromJson(json);
  }
  @HiveField(0)
  final int? id;

  /// we dont need to store jwtToken in hive
  final String? jwtToken;
  @HiveField(2)
  final String? name;
  @HiveField(3)
  @JsonKey(name: 'emailAddress')
  final String? email;
  @HiveField(4)
  final String? password;
  @HiveField(5)
  final String? phone;
  @override
  String get key => id.toString();

  @override
  // TODO: implement props
  List<Object?> get props => [id, jwtToken, name, email, password, phone];

  @override
  Map<String, dynamic> toJson() {
    return _$UserModelToJson(this);
  }

  UserModel copyWith({
    ValueGetter<int?>? id,
    ValueGetter<String?>? jwtToken,
    ValueGetter<String?>? name,
    ValueGetter<String?>? email,
    ValueGetter<String?>? password,
    ValueGetter<String?>? phone,
  }) {
    return UserModel(
      id: id != null ? id() : this.id,
      jwtToken: jwtToken != null ? jwtToken() : this.jwtToken,
      name: name != null ? name() : this.name,
      email: email != null ? email() : this.email,
      password: password != null ? password() : this.password,
      phone: phone != null ? phone() : this.phone,
    );
  }
}
