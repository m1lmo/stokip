// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_cubit.dart';

class UserState extends Equatable {
  const UserState({this.currentUser});
  final UserModel? currentUser;

  @override
  List<Object> get props => [currentUser!];

  UserState copyWith({
    UserModel? currentUser,
  }) {
    return UserState(
      currentUser: currentUser ?? this.currentUser,
    );
  }
}