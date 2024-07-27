part of 'customer_cubit.dart';

final class CustomerState extends Equatable {
  CustomerState({this.totalBalance, this.customers});
  final List<CustomerModel>? customers;
  final double? totalBalance;

  @override
  List<Object?> get props => [customers, totalBalance,];

  @override
  int get hashCode => customers.hashCode ^ totalBalance.hashCode ;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CustomerState && runtimeType == other.runtimeType && customers == other.customers && totalBalance == other.totalBalance;

  CustomerState copyWith({
    List<CustomerModel>? customers,
    double? totalBalance,
  }) {
    return CustomerState(
      totalBalance: totalBalance ?? this.totalBalance,
      customers: customers ?? this.customers,
    );
  }
}
