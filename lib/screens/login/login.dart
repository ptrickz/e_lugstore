import 'package:e_lugstore/constants/bg.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Background(
        hasDrawer: false,
        pageTitle: "Login",
        assetImage: "assets/images/login.png",
        appBarLeading: () {
          Navigator.pop(context);
        },
        icon: Icons.chevron_left,
        child: const Center(
          child: Text("Login Page"),
        ));
  }
}
