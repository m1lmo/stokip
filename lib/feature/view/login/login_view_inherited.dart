import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stokip/feature/cubit/user/user_cubit.dart';
import 'package:stokip/feature/service/repository/user_repository.dart';
import 'package:stokip/feature/view/home_view.dart';
import 'package:stokip/feature/view/login/login_view.dart';
import 'package:stokip/product/helper/dio_helper.dart';
import 'package:stokip/product/navigator_manager.dart';

/// This class is used to pass the state of [LoginViewHost] to [LoginView]
final class LoginViewInherited extends InheritedWidget {
  const LoginViewInherited(this.data, {required super.child, super.key});
  final LoginViewHostState data;

  static LoginViewHostState of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<LoginViewInherited>();
    if (result != null) {
      return result.data;
    } else {
      // ignore: lines_longer_than_80_chars
      throw Exception('LoginViewInherited not found in context, please check the context passed');
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

/// This class is used to host the state of [LoginView]
class LoginViewHost extends StatefulWidget {
  const LoginViewHost({super.key});

  @override
  State<LoginViewHost> createState() => LoginViewHostState();
}

class LoginViewHostState extends State<LoginViewHost> with NavigatorManager {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final dioHelper = DioHelper.instance();
  late final UserRepository userRepository;

  @override
  void initState() {
    super.initState();
    userRepository = UserRepository(dioHelper.dio);
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> loginMethod() async {
    await context.read<UserCubit>().loginMethod(
      emailController.text,
      passwordController.text,
      onSuccess: () {
        navigateToPageReplaced(context, const HomeView());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoginViewInherited(this, child: const LoginView());
  }
}
