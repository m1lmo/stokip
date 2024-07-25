import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stokip/feature/cubit/user/user_cubit.dart';
import 'package:stokip/feature/view/home_view.dart';
import 'package:stokip/feature/view/login/login_view_inherited.dart';
import 'package:stokip/feature/view/splash/splash_view.dart';
import 'package:stokip/product/navigator_manager.dart';

/// This class is used to pass the state of [SplashViewHost] to [SplashView]
final class SplashViewInherited extends InheritedWidget {
  const SplashViewInherited(this.data, {required super.child, super.key});
  final SplashViewHostState data;

  static SplashViewHostState of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<SplashViewInherited>();
    if (result != null) {
      return result.data;
    } else {
      throw Exception('SplashViewInherited not found in context');
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

/// This class is used to host the state of [SplashView]
class SplashViewHost extends StatefulWidget {
  const SplashViewHost({super.key});

  @override
  State<SplashViewHost> createState() => SplashViewHostState();
}

class SplashViewHostState extends State<SplashViewHost> with NavigatorManager {
  // Add your state and logic here
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().init.then(
      (value) {
        if (context.read<UserCubit>().getUser != null) {
          navigateToPageReplaced(context, const HomeView());
        } else {
          navigateToPageReplaced(context, const LoginViewHost());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SplashViewInherited(this, child: const SplashView());
  }
}
