// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerModelAdapter extends TypeAdapter<CustomerModel> {
  @override
  final int typeId = 7;

  @override
  CustomerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomerModel(
      id: fields[0] as int,
      title: fields[1] as String?,
      balance: fields[2] as double?,
      boughtProducts: (fields[3] as List?)?.cast<SalesModel>(),
      currency: fields[5] as CurrencyEnum,
    );
  }

  @override
  void write(BinaryWriter writer, CustomerModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.balance)
      ..writeByte(3)
      ..write(obj.boughtProducts)
      ..writeByte(4)
      ..write(obj.payments)
      ..writeByte(5)
      ..write(obj.currency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerModel _$CustomerModelFromJson(Map<String, dynamic> json) =>
    CustomerModel(
      id: (json['customerId'] as num).toInt(),
      title: json['name'] as String?,
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
      currency:
          $enumDecodeNullable(_$CurrencyEnumEnumMap, json['currencyType']) ??
              CurrencyEnum.usd,
    );

Map<String, dynamic> _$CustomerModelToJson(CustomerModel instance) =>
    <String, dynamic>{
      'customerId': instance.id,
      'name': instance.title,
      'balance': instance.balance,
      'currencyType': _$CurrencyEnumEnumMap[instance.currency]!,
    };

const _$CurrencyEnumEnumMap = {
  CurrencyEnum.tl: 'tl',
  CurrencyEnum.usd: 'usd',
  CurrencyEnum.nullValue: '',
};
