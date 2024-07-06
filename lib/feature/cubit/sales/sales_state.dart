// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'sales_cubit.dart';

final class SalesState with EquatableMixin {
  SalesState({
    this.salesId = 0,
    this.sales,
    this.filteredSales,
    this.totalIncome,
    this.trendProduct,
    this.monthlySoldAmount = 0.0,
    this.monthlySoldMeter = 0.0,
  });
  int salesId;
  double? totalIncome;
  final List<SalesModel>? sales;
  final List<SalesModel>? filteredSales;
  final StockModel? trendProduct;
  final double monthlySoldAmount;
  final double monthlySoldMeter;
  @override
  List<Object?> get props => [
        sales,
        filteredSales,
        salesId,
        totalIncome,
        trendProduct,
        monthlySoldAmount,
        monthlySoldMeter,
      ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalesState &&
          runtimeType == other.runtimeType &&
          sales == other.sales &&
          filteredSales == other.filteredSales &&
          salesId == other.salesId &&
          totalIncome == other.totalIncome &&
          trendProduct == other.trendProduct &&
          monthlySoldAmount == other.monthlySoldAmount &&
          monthlySoldMeter == other.monthlySoldMeter;

  @override
  int get hashCode =>
      sales.hashCode ^ filteredSales.hashCode ^ salesId.hashCode ^ totalIncome.hashCode ^ trendProduct.hashCode ^ monthlySoldMeter.hashCode ^ monthlySoldAmount.hashCode;

  SalesState copyWith({
    int? salesId,
    List<SalesModel>? sales,
    List<SalesModel>? filteredSales,
    String? selectedItemOnSales,
    String? selectedSpecific,
    CurrencyEnum? currency,
    double? totalIncome,
    StockModel? trendProduct,
    double? monthlySoldAmount,
    double? monthlySoldMeter,
  }) {
    return SalesState(
      salesId: salesId ?? this.salesId,
      sales: sales ?? this.sales,
      filteredSales: filteredSales ?? this.filteredSales,
      totalIncome: totalIncome ?? this.totalIncome,
      trendProduct: trendProduct ?? this.trendProduct,
      monthlySoldAmount: monthlySoldAmount ?? this.monthlySoldAmount,
      monthlySoldMeter: monthlySoldMeter ?? this.monthlySoldMeter,
    );
  }
}
