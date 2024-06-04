// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'stock_cubit.dart';

// ignore: must_be_immutable
class StockState extends Equatable {
  final List<StockModel>? products;
  final List<StockDetailModel>? details;
  int productId;
  String? appBarTitle;
  double? totalMeter;
  StockModel? runningOutStock;
  double? totalAmount;
  StockState({
    this.productId = 0,
    this.products,
    this.details,
    this.appBarTitle,
    this.totalMeter,
    this.runningOutStock,
    this.totalAmount,
  });

  @override
  List<Object?> get props {
    return [
      products,
      details,
      productId,
      appBarTitle,
      totalMeter,
      runningOutStock,
      totalAmount,
    ];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockState &&
          runtimeType == other.runtimeType &&
          products == other.products &&
          details == other.details &&
          productId == other.productId &&
          runningOutStock == other.runningOutStock &&
          totalMeter == other.totalMeter &&
          totalAmount == other.totalAmount &&
          appBarTitle == other.appBarTitle;

  @override
  int get hashCode => products.hashCode ^ details.hashCode ^ productId.hashCode ^ runningOutStock.hashCode ^ totalMeter.hashCode ^ appBarTitle.hashCode ^ totalAmount.hashCode;

  StockState copyWith({
    List<StockModel>? products,
    List<StockDetailModel>? details,
    int? productId,
    String? appBarTitle,
    double? totalMeter,
    StockModel? runningOutStock,
    double? totalAmount,
  }) {
    return StockState(
      products: products ?? this.products,
      details: details ?? this.details,
      productId: productId ?? this.productId,
      appBarTitle: appBarTitle ?? this.appBarTitle,
      totalMeter: totalMeter ?? this.totalMeter,
      runningOutStock: runningOutStock ?? this.runningOutStock,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}
