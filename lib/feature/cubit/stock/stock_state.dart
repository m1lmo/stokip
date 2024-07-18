part of 'stock_cubit.dart';

// ignore: must_be_immutable
class StockState extends Equatable {
  StockState({
    this.productId = 0,
    this.productDetailId = 0,
    this.products,
    this.details,
    this.appBarTitle,
    this.totalMeter,
    this.runningOutStock,
    this.runningOutStockDetail,
    this.trendStockDetail,
    this.totalAmount,
  });
  final List<StockModel>? products;
  final List<StockDetailModel>? details;

  /// this is used for cache logic
  ///
  /// dont use for fetch products
  int productId;
  int productDetailId;
  String? appBarTitle;
  double? totalMeter;
  StockModel? runningOutStock;
  StockDetailModel? runningOutStockDetail;
  StockDetailModel? trendStockDetail;

  double? totalAmount;

  @override
  List<Object?> get props {
    return [
      products,
      details,
      productId,
      productDetailId,
      appBarTitle,
      totalMeter,
      runningOutStock,
      runningOutStockDetail,
      trendStockDetail,
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
          productDetailId == other.productDetailId &&
          runningOutStock == other.runningOutStock &&
          runningOutStockDetail == other.runningOutStockDetail &&
          trendStockDetail == other.trendStockDetail &&
          totalMeter == other.totalMeter &&
          totalAmount == other.totalAmount &&
          appBarTitle == other.appBarTitle;

  @override
  int get hashCode =>
      products.hashCode ^
      details.hashCode ^
      productId.hashCode ^
      productDetailId.hashCode ^
      runningOutStock.hashCode ^
      runningOutStockDetail.hashCode ^
      trendStockDetail.hashCode ^
      totalMeter.hashCode ^
      appBarTitle.hashCode ^
      totalAmount.hashCode;

  StockState copyWith({
    List<StockModel>? products,
    List<StockDetailModel>? details,
    int? productId,
    int? productDetailId,
    String? appBarTitle,
    double? totalMeter,
    StockModel? runningOutStock,
    StockDetailModel? runningOutStockDetail,
    StockDetailModel? trendStockDetail,
    double? totalAmount,
  }) {
    return StockState(
      products: products ?? this.products,
      details: details ?? this.details,
      productId: productId ?? this.productId,
      productDetailId: productDetailId ?? this.productDetailId,
      appBarTitle: appBarTitle ?? this.appBarTitle,
      totalMeter: totalMeter ?? this.totalMeter,
      runningOutStock: runningOutStock ?? this.runningOutStock,
      runningOutStockDetail: runningOutStockDetail ?? this.runningOutStockDetail,
      trendStockDetail: trendStockDetail ?? this.trendStockDetail,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}
