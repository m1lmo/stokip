import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:stokip/feature/model/customer_model.dart';
import 'package:stokip/product/cache/shared_manager.dart';
import 'package:stokip/product/constants/enums/currency_enum.dart';
import 'package:stokip/product/database/core/database_hive_manager.dart';
import 'package:stokip/product/database/operation/customer_hive_operation.dart';
import 'package:stokip/product/widgets/c_notify.dart';

part 'customer_state.dart';

final class CustomerCubit extends Cubit<CustomerState> {
  CustomerCubit() : super(CustomerState());
  final List<CustomerModel> customers = [];
  late final SharedManager sharedManager;
  final databaseOperation = CustomerHiveOperation();
  late final TickerProvider tickerProviderService;

  /// init method for [CustomerCubit]
  Future<void> init(TickerProvider ticker) async {
    try {
      await DatabaseHiveManager().start();
      await databaseOperation.start();
      sharedManager = await SharedManager.getInstance;
      if (databaseOperation.box.isNotEmpty) {
        customers.addAll(databaseOperation.box.values);
      }
      readId();
      emit(state.copyWith(customers: customers));
      updateTotalBalanceUSD();
      tickerProviderService = ticker;
    } catch (e) {
      print(e);
    }
  }

  void readId() {
    final result = sharedManager.prefs.getInt('customerid');
    return emit(state.copyWith(id: result));
  }

  void writeIdToCache() {
    if (state.id == null) return emit(state.copyWith(id: 0));
    sharedManager.prefs.setInt('customerid', state.id! + 1);
    emit(state.copyWith(id: state.id! + 1));
    print(state.id);
  }

  void addCustomer(CustomerModel customer, BuildContext context) {
    if (customers.isNotEmpty) {
      if (customers.where((element) => element.title?.toLowerCase() == customer.title?.toLowerCase()).isNotEmpty) {
        return CNotify(
          tickerProviderService: tickerProviderService,
          overlayState: Overlay.of(context),
          title: 'Hata',
          message: 'Bu isimde bir müşteri zaten var',
        ).show();
      }
    }
    writeIdToCache();
    customers.add(customer);
    databaseOperation.addOrUpdateItem(customer);
    updateTotalBalanceUSD();
    return emit(state.copyWith(customers: List.from(customers)));
  }

  void updateCustomerBalance(CustomerModel customer, double balance) {
    customer.balance = (customer.balance ?? 0) + balance;
    databaseOperation.addOrUpdateItem(customer);
    emit(state.copyWith(customers: List.from(customers)));
  }

  void updateCustomerBoughtedProducts() {}

  void updateTotalBalanceUSD() {
    final totalBalance = customers.fold<double>(0, (previousValue, element) {
      if (element.currency == CurrencyEnum.usd) return previousValue + (element.balance ?? 0);
      return previousValue;
    });
    return emit(state.copyWith(totalBalance: totalBalance));
  }
}
