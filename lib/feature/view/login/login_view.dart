import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:stokip/feature/view/login/login_view_inherited.dart';
import 'package:stokip/product/constants/custom_icon.dart';
import 'package:stokip/product/constants/my_button_style.dart';
import 'package:stokip/product/constants/project_paddings.dart';

@immutable
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            _LoginWithPassword(),
            _OrLoginWith(),
            _LoginAndSignButton(),
          ],
        ),
      ),
    );
  }
}

class _LoginAndSignButton extends StatelessWidget {
  const _LoginAndSignButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 57.h,
      left: 0,
      right: 0,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: MyButtonStyle.loginButtonStyle,
              onPressed: () {},
              child: const Text('SIGNUP'),
            ),
            SizedBox(width: 5.w),
            ElevatedButton(
              style: MyButtonStyle.registerButtonStyle,
              onPressed: () {},
              child: const Text('LOGIN'),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrLoginWith extends StatelessWidget {
  const _OrLoginWith({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: SizedBox(
        height: 40.h,
        child: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Column(
            children: [
              Text(
                'or login with',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 5.h),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                  ),
                ),
                child: const Icon(
                  CustomIcons.google,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Text(
                    "Don't Have an account?" ' ',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade900),
                  ),
                  TextButton(
                    style: const ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.zero)),
                    onPressed: () {},
                    child: Text(
                      'Sign Up',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginWithPassword extends StatelessWidget {
  const _LoginWithPassword({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentState = LoginViewInherited.of(context);
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 60.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(40.sp),
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: SafeArea(
          child: Padding(
            padding: ProjectPaddings.mainPadding(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(height: 5.h),
                TextFormField(
                  controller: currentState.emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                SizedBox(height: 3.h),
                TextFormField(
                  controller: currentState.passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () async {
                      await currentState.loginMethod();
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
