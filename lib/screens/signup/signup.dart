import 'package:e_lugstore/constants/bg.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Background(
        hasDrawer: false,
        pageTitle: "Sign Up",
        assetImage: "assets/images/signup.png",
        appBarLeading: () {
          Navigator.pop(context);
        },
        icon: Icons.chevron_left,
        child: const Center(
          child: Text("Sign Up Page"),
        ));
  }
}
