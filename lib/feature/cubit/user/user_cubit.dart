import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stokip/feature/model/user_model.dart';
import 'package:stokip/feature/service/repository/user_repository.dart';
import 'package:stokip/product/database/core/database_hive_manager.dart';
import 'package:stokip/product/database/operation/user_hive_operation.dart';
import 'package:stokip/product/helper/dio_helper.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserState());

  UserModel? currentUser;

  late final UserHiveOperation userHiveOperation = UserHiveOperation();
  late final FlutterSecureStorage jwtCache;
  late final UserRepository userRepository;
  final dioHelper = DioHelper.instance();

  Future<void> get init async {
    await DatabaseHiveManager().start();
    await userHiveOperation.start();
    userRepository = UserRepository(dioHelper.dio);
    jwtCache = const FlutterSecureStorage();
    await jwtCache.read(key: 'jwt').then((value) {
      if (value != null) {
        // dioHelper.dio.options.headers['Authorization'] = value;
        // userRepository.postWithResponse(UserModel()).then((value) {
        //   if (value != null) {
        //     currentUser = value;
        //     userHiveOperation.addOrUpdateItem(currentUser!);
        //     emit(state.copyWith(currentUser: currentUser));
        //   }
        // });
      }
    });
    emit(state.currentUser != null ? state : state.copyWith(currentUser: currentUser));
  }

  UserModel? get getUser {
    print('aaa');
    return currentUser;
  }

  void setUser(UserModel user) {
    currentUser = user.copyWith(
      jwtToken: () {
        return null;
      },
    );
    jwtCache.write(key: 'jwt', value: user.jwtToken);
    userHiveOperation.addOrUpdateItem(currentUser!);
    emit(state.copyWith(currentUser: currentUser));
  }
}
