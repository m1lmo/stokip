part of 'customer_cubit.dart';

final class CustomerState extends Equatable {
  CustomerState({this.id = 0, this.totalBalance, this.customers});
  final List<CustomerModel>? customers;
  final double? totalBalance;
  final int? id;

  @override
  List<Object?> get props => [customers, totalBalance, id];

  @override
  int get hashCode => customers.hashCode ^ totalBalance.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CustomerState && runtimeType == other.runtimeType && customers == other.customers && totalBalance == other.totalBalance && id == other.id;

  CustomerState copyWith({
    List<CustomerModel>? customers,
    double? totalBalance,
    int? id,
  }) {
    return CustomerState(
      totalBalance: totalBalance ?? this.totalBalance,
      customers: customers ?? this.customers,
      id: id ?? this.id,
    );
  }
}
