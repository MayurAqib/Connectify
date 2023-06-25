import 'package:flutter/material.dart';

import '../pages/login_page.dart';
import '../pages/register_page.dart';

class LoginRegisterToggle extends StatefulWidget {
  const LoginRegisterToggle({super.key});

  @override
  State<LoginRegisterToggle> createState() => _LoginRegisterTogglestate();
}

class _LoginRegisterTogglestate extends State<LoginRegisterToggle> {
  bool showLoginPage = true;
  void togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: togglePage);
    } else {
      return RegisterPage(onTap: togglePage);
    }
  }
}
