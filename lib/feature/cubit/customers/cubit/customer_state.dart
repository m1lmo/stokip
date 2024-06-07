part of 'customer_cubit.dart';

final class CustomerState extends Equatable {
  const CustomerState({this.customers});
  final List<CustomerModel>? customers;
  @override
  List<Object?> get props => [customers];
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CustomerState && listEquals(other.customers, customers);
  }

  CustomerState copyWith({
    List<CustomerModel>? customers,
  }) {
    return CustomerState(
      customers: customers ?? this.customers,
    );
  }
}
