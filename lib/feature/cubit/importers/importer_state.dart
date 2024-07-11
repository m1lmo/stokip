// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'importer_cubit.dart';

@immutable
class ImporterState with EquatableMixin {
  ImporterState({
    this.importers,
    this.importerId = 0,
    this.imageFile,
    this.selectedCurrency,
    this.salesId = 0,
    this.totalBalance = 0,
  });
  final List<ImporterModel>? importers;
  final int importerId;
  final int salesId;
  final File? imageFile;
  final CurrencyEnum? selectedCurrency;
  final double totalBalance;

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
          totalBalance == other.totalBalance &&
          selectedCurrency == other.selectedCurrency;

  @override
  int get hashCode => importers.hashCode ^ importerId.hashCode ^ selectedCurrency.hashCode ^ salesId.hashCode ^ totalBalance.hashCode;
  ImporterState copyWith({
    List<ImporterModel>? importers,
    int? importerId,
    int? salesId,
    File? imageFile,
    CurrencyEnum? selectedCurrency,
    double? totalBalance,
  }) {
    return ImporterState(
      importers: importers ?? this.importers,
      importerId: importerId ?? this.importerId,
      salesId: salesId ?? this.salesId,
      imageFile: imageFile ?? this.imageFile,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      totalBalance: totalBalance ?? this.totalBalance,
    );
  }
}
