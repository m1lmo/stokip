import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stokip/feature/model/user_model.dart';
import 'package:stokip/product/database/core/database_hive_manager.dart';
import 'package:stokip/product/database/operation/user_hive_operation.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserState());

  UserModel? currentUser;
  late final UserHiveOperation userHiveOperation = UserHiveOperation();
  late final FlutterSecureStorage jwtCache;

  Future<void> init() async {
    await DatabaseHiveManager().start();
    await userHiveOperation.start();
    jwtCache = const FlutterSecureStorage();
    if (userHiveOperation.box.isNotEmpty) {
      currentUser = userHiveOperation.box.values.first;
      await jwtCache.read(key: 'jwt').then((value) {
        if (value != null) {
          emit(
            state.copyWith(
              currentUser: currentUser!.copyWith(
                jwtToken: () {
                  return value;
                },
              ),
            ),
          );
        }
      });
    }
    emit(state.currentUser != null ? state : state.copyWith(currentUser: currentUser));
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
