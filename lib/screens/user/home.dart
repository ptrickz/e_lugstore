import 'package:e_lugstore/constants/bg.dart';
import 'package:flutter/material.dart';

class UseerHome extends StatefulWidget {
  const UseerHome({super.key});

  @override
  State<UseerHome> createState() => _UseerHomeState();
}

class _UseerHomeState extends State<UseerHome> {
  @override
  Widget build(BuildContext context) {
    return const Background(
        isStaff: false,
        hasDrawer: true,
        pageTitle: "Welcome, User",
        assetImage: "assets/images/homeUser.png",
        child: Center(
          child: Text("User Home Page"),
        ));
  }
}
