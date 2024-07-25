// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_cubit.dart';

class UserState with EquatableMixin {
  const UserState({this.currentUser});
  final UserModel? currentUser;
  // final bool haveInternetConnection;

  @override
  List<Object?> get props => [currentUser];

  @override
  int get hashCode => currentUser.hashCode;

  UserState copyWith({
    UserModel? currentUser,
  }) {
    return UserState(
      currentUser: currentUser ?? this.currentUser,
    );
  }
}
