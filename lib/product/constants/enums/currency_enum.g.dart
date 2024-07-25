// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrencyEnumAdapter extends TypeAdapter<CurrencyEnum> {
  @override
  final int typeId = 4;

  @override
  CurrencyEnum read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CurrencyEnum.tl;
      case 1:
        return CurrencyEnum.usd;
      case 2:
        return CurrencyEnum.nullValue;
      default:
        return CurrencyEnum.tl;
    }
  }

  @override
  void write(BinaryWriter writer, CurrencyEnum obj) {
    switch (obj) {
      case CurrencyEnum.tl:
        writer.writeByte(0);
        break;
      case CurrencyEnum.usd:
        writer.writeByte(1);
        break;
      case CurrencyEnum.nullValue:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyEnumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
