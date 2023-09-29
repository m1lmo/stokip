// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'importer_cubit.dart';

class ImporterState with EquatableMixin {
  ImporterState({
    this.importers,
    this.importerId = 0,
    this.imageFile,
    this.selectedCurrency,
    this.salesId = 0,

  });
  final List<ImporterModel>? importers;
  int importerId;
  int salesId;
  File? imageFile;
  CurrencyEnum? selectedCurrency;


  @override
  List<Object?> get props => [
        importers,
        importerId,
        selectedCurrency,

      ];
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImporterState &&
          runtimeType == other.runtimeType &&
          importers == other.importers &&
          importerId == other.importerId &&
          salesId == other.salesId &&
          selectedCurrency == other.selectedCurrency;

  @override
  int get hashCode =>
      importers.hashCode ^
      importerId.hashCode ^
      selectedCurrency.hashCode ^
      salesId.hashCode;
  ImporterState copyWith({
    List<ImporterModel>? importers,
    int? importerId,
    int? salesId,
    File? imageFile,
    CurrencyEnum? selectedCurrency,

  }) {
    return ImporterState(
      importers: importers ?? this.importers,
      importerId: importerId ?? this.importerId,
      salesId: salesId ?? this.salesId,
      imageFile: imageFile ?? this.imageFile,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,

    );
  }
}
