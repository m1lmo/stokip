import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stokip/feature/model/customer_model.dart';
import 'package:stokip/feature/model/sales_model.dart';
import 'package:stokip/feature/service/repository/customer_repository.dart';
import 'package:stokip/product/cache/shared_manager.dart';
import 'package:stokip/product/constants/enums/currency_enum.dart';
import 'package:stokip/product/database/core/database_hive_manager.dart';
import 'package:stokip/product/database/operation/customer_hive_operation.dart';
import 'package:stokip/product/helper/dio_helper.dart';
import 'package:stokip/product/widgets/c_notify.dart';
import 'package:stokip/test_global.dart' as globals;

part 'customer_state.dart';

final class CustomerCubit extends Cubit<CustomerState> {
  CustomerCubit({
    required this.sales,
  }) : super(CustomerState());
  final List<SalesModel> sales;
  final List<CustomerModel> customers = [];
  final databaseOperation = CustomerHiveOperation();
  final dioHelper = DioHelper.instance();
  late final SharedManager sharedManager; //TODO REMOVE
  late final CustomerRepository customerRepository;
  final secureStorage = const FlutterSecureStorage();

  /// init method for [CustomerCubit]
  Future<void> init() async {
    await DatabaseHiveManager().start();
    await databaseOperation.start();
    dioHelper.setToken(await secureStorage.read(key: 'jwt'));
    customerRepository = CustomerRepository(dioHelper.dio);
    sharedManager = await SharedManager.getInstance;
    if (databaseOperation.box.isNotEmpty && !globals.globalInternetConnection) {
      customers.addAll(databaseOperation.box.values);
    } else {
      final data = await customerRepository.fetchData();
      if (data == null) return;
      for (final item in data) {
        if (item == null) continue;
        customers.add(item);
        // await databaseOperation.addOrUpdateItem(item);
      }
    }
    readId();
    emit(state.copyWith(customers: customers));
    updateTotalBalanceUSD();
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
          title: 'Hata',
          message: 'Bu isimde bir müşteri zaten var',
        ).show();
      }
    }
    customerRepository.postData(customer);
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

  void updateCustomerBoughtedProducts() {
    for (final customer in customers) {
      final boughtedProducts = sales.where((element) => element.customer == customer).toList();
      customer.boughtProducts = List.from(boughtedProducts);
      databaseOperation.addOrUpdateItem(customer);
    }
    emit(state.copyWith(customers: List.from(customers)));
  }

  void updateTotalBalanceUSD() {
    final totalBalance = customers.fold<double>(0, (previousValue, element) {
      if (element.currency == CurrencyEnum.usd) return previousValue + (element.balance ?? 0);
      return previousValue;
    });
    return emit(state.copyWith(totalBalance: totalBalance));
  }
}
