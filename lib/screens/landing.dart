import 'package:e_lugstore/screens/signup/signup.dart';
import 'package:e_lugstore/screens/staff/home.dart';
import 'package:e_lugstore/screens/user/home.dart';
import 'package:e_lugstore/widgets/button.dart';
import 'package:flutter/material.dart';

import 'login/login.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(55, 20, 55, 20),
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/eluggage.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                width: 100,
                height: 100,
              ),
            ),
            MyButton(
                text: "Login",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                }),
            MyButton(
                text: "Sign Up",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()));
                }),
            MyButton(
                text: "For Staff",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StaffHome()));
                }),
            MyButton(
              text: "For User",
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const UseerHome()));
              },
            ),
          ],
        ),
      ),
    );
  }
}