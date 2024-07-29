import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:stokip/feature/model/user_model.dart';
import 'package:stokip/feature/service/repository/user_repository.dart';
import 'package:stokip/product/cache/storage_manager.dart';
import 'package:stokip/product/database/core/database_hive_manager.dart';
import 'package:stokip/product/database/operation/user_hive_operation.dart';
import 'package:stokip/product/helper/dio_helper.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserState());

  UserModel? currentUser;

  final userHiveOperation = UserHiveOperation();
  final secureStorage = StorageManager.instance();
  final dioHelper = DioHelper.instance();
  late final UserRepository userRepository;

  Future<void> get init async {
    await DatabaseHiveManager().start();
    await userHiveOperation.start();
    userRepository = UserRepository(dioHelper.dio);
    dioHelper.setToken(await secureStorage.getToken);
    emit(state.currentUser != null ? state : state.copyWith(currentUser: currentUser));
  }

  UserModel? get getUser {
    return currentUser;
  }

  Future<void> loginMethod(String email, String password, {required VoidCallback onSuccess}) async {
    final user = UserModel(email: email, password: password);
    final response = await userRepository.postWithResponse(user);
    if (response == null) return;
    setUser(response);
    onSuccess.call();
  }

  void setUser(UserModel user) {
    currentUser = user.copyWith(
      jwtToken: () {
        return null;
      },
    );
    secureStorage.writeToken(user.jwtToken!);
    userHiveOperation.addOrUpdateItem(currentUser!);
    emit(state.copyWith(currentUser: currentUser));
  }
}
