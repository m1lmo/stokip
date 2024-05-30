// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SalesModelAdapter extends TypeAdapter<SalesModel> {
  @override
  final int typeId = 2;

  @override
  SalesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SalesModel(
      id: fields[0] as int,
      dateTime: fields[3] as DateTime,
      title: fields[1] as String?,
      meter: fields[2] as double?,
      price: fields[4] as double?,
      currency: fields[5] as CurrencyEnum?,
    );
  }

  @override
  void write(BinaryWriter writer, SalesModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.meter)
      ..writeByte(3)
      ..write(obj.dateTime)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.currency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesModel _$SalesModelFromJson(Map<String, dynamic> json) => SalesModel(
      id: (json['id'] as num).toInt(),
      dateTime: DateTime.parse(json['dateTime'] as String),
      title: json['title'] as String?,
      meter: (json['meter'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      currency: $enumDecodeNullable(_$CurrencyEnumEnumMap, json['currency']),
    );

Map<String, dynamic> _$SalesModelToJson(SalesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'meter': instance.meter,
      'dateTime': instance.dateTime.toIso8601String(),
      'price': instance.price,
      'currency': _$CurrencyEnumEnumMap[instance.currency],
    };

const _$CurrencyEnumEnumMap = {
  CurrencyEnum.tl: 'tl',
  CurrencyEnum.usd: 'usd',
};
