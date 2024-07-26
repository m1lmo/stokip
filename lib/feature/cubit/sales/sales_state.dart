// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'sales_cubit.dart';

@immutable
final class SalesState with EquatableMixin {
  SalesState({
    this.salesId = 0,
    this.sales,
    this.topCustomer,
    this.filteredSales,
    this.totalIncome,
    this.trendProduct,
    this.monthlySoldAmount = 0.0,
    this.monthlySoldMeter = 0.0,
  });
  final int salesId;
  final double? totalIncome;
  final List<SalesModel>? sales;
  final List<SalesModel>? filteredSales;
  final StockModel? trendProduct;
  final double monthlySoldAmount;
  final double monthlySoldMeter;
  final CustomerModel? topCustomer;
  @override
  List<Object?> get props => [
        sales,
        filteredSales,
        salesId,
        totalIncome,
        trendProduct,
        monthlySoldAmount,
        monthlySoldMeter,
        topCustomer,
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
          topCustomer == other.topCustomer &&
          monthlySoldAmount == other.monthlySoldAmount &&
          monthlySoldMeter == other.monthlySoldMeter;

  @override
  int get hashCode =>
      sales.hashCode ^
      filteredSales.hashCode ^
      salesId.hashCode ^
      totalIncome.hashCode ^
      trendProduct.hashCode ^
      monthlySoldMeter.hashCode ^
      topCustomer.hashCode ^
      monthlySoldAmount.hashCode;

  SalesState copyWith({
    int? salesId,
    List<SalesModel>? sales,
    List<SalesModel>? filteredSales,
    String? selectedItemOnSales,
    String? selectedSpecific,
    CurrencyEnum? currency,
    double? totalIncome,
    double? highestSale,
    StockModel? trendProduct,
    double? monthlySoldAmount,
    CustomerModel? topCustomer,
    double? monthlySoldMeter,
  }) {
    return SalesState(
      salesId: salesId ?? this.salesId,
      sales: sales ?? this.sales,
      filteredSales: filteredSales ?? this.filteredSales,
      totalIncome: totalIncome ?? this.totalIncome,
      trendProduct: trendProduct ?? this.trendProduct,
      topCustomer: topCustomer ?? this.topCustomer,
      monthlySoldAmount: monthlySoldAmount ?? this.monthlySoldAmount,
      monthlySoldMeter: monthlySoldMeter ?? this.monthlySoldMeter,
    );
  }
}
