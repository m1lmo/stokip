// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'sales_cubit.dart';

final class SalesState with EquatableMixin {
  SalesState({
    this.salesId = 0,
    this.sales,
    this.selectedItemOnSales,
    this.selectedSpecific,
    this.currency,
    this.totalIncome,
  });
  int salesId;
  double? totalIncome;
  final List<SalesModel>? sales;
  //todo final olmayabilir
  final String? selectedItemOnSales;
  final String? selectedSpecific;
  final CurrencyEnum? currency;

  @override
  List<Object?> get props => [
        sales,
        selectedItemOnSales,
        salesId,
        selectedSpecific,
        currency,
        totalIncome,
      ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalesState &&
          runtimeType == other.runtimeType &&
          sales == other.sales &&
          selectedItemOnSales == other.selectedItemOnSales &&
          salesId == other.salesId &&
          selectedSpecific == other.selectedItemOnSales &&
          totalIncome == other.totalIncome &&
          currency == other.currency;

  @override
  int get hashCode => sales.hashCode ^ selectedItemOnSales.hashCode ^ salesId.hashCode ^ selectedSpecific.hashCode ^ currency.hashCode ^ totalIncome.hashCode;

  SalesState copyWith({
    int? salesId,
    List<SalesModel>? sales,
    String? selectedItemOnSales,
    String? selectedSpecific,
    CurrencyEnum? currency,
    double? totalIncome,
  }) {
    return SalesState(
      salesId: salesId ?? this.salesId,
      sales: sales ?? this.sales,
      selectedItemOnSales: selectedItemOnSales ?? this.selectedItemOnSales,
      selectedSpecific: selectedSpecific ?? this.selectedSpecific,
      currency: currency ?? this.currency,
      totalIncome: totalIncome ?? this.totalIncome,
    );
  }
}
