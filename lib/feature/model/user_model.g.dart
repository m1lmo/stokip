// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 8;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      name: fields[2] as String?,
      email: fields[3] as String?,
      password: fields[4] as String?,
      phone: fields[5] as String?,
      id: fields[0] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.password)
      ..writeByte(5)
      ..write(obj.phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      jwtToken: json['jwtToken'] as String?,
      name: json['name'] as String?,
      email: json['emailAddress'] as String?,
      password: json['password'] as String?,
      phone: json['phone'] as String?,
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'jwtToken': instance.jwtToken,
      'name': instance.name,
      'emailAddress': instance.email,
      'password': instance.password,
      'phone': instance.phone,
    };
