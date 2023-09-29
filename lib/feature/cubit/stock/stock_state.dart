// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'stock_cubit.dart';

// ignore: must_be_immutable
class StockState extends Equatable {
  final List<StockModel>? products;
  final List<StockDetailModel>? details;
  int productId;
  String? appBarTitle;
  double? totalMeter;

  StockState({
    this.productId = 0,
    this.products,
    this.details,
    this.appBarTitle,
    this.totalMeter,
  });

  List<Object?> get props {
    return [
      products,
      details,
      productId,
      appBarTitle,
      totalMeter,
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
          totalMeter == other.totalMeter &&
          appBarTitle == other.appBarTitle;

  @override
  int get hashCode =>
      products.hashCode ^
      details.hashCode ^
      productId.hashCode ^
      totalMeter.hashCode ^
      appBarTitle.hashCode;

  StockState copyWith({
    List<StockModel>? products,
    List<StockDetailModel>? details,
    int? productId,
    String? appBarTitle,
    double? totalMeter,
  }) {
    return StockState(
      products: products ?? this.products,
      details: details ?? this.details,
      productId: productId ?? this.productId,
      appBarTitle: appBarTitle ?? this.appBarTitle,
      totalMeter: totalMeter ?? this.totalMeter,
    );
  }
}
