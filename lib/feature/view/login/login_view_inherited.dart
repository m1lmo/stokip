import 'package:flutter/widgets.dart';
import 'package:stokip/feature/model/user_model.dart';
import 'package:stokip/feature/service/repository/user_repository.dart';
import 'package:stokip/feature/view/login/login_view.dart';
import 'package:stokip/product/helper/dio_helper.dart';

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

class LoginViewHostState extends State<LoginViewHost> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final dioHelper = DioHelper.instance();
  late final UserRepository userRepository;

  @override
  void initState() {
    super.initState();
    userRepository = UserRepository(dioHelper.dio);
  }

  Future<void> loginMethod() async {
    final response = await userRepository.postWithResponse(UserModel(email: emailController.text, password: passwordController.text));
    if (response != null) {
      print(response.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoginViewInherited(this, child: const LoginView());
  }
}
