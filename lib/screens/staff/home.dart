import 'package:e_lugstore/constants/bg.dart';
import 'package:flutter/material.dart';

class StaffHome extends StatefulWidget {
  const StaffHome({super.key});

  @override
  State<StaffHome> createState() => _StaffHomeState();
}

class _StaffHomeState extends State<StaffHome> {
  @override
  Widget build(BuildContext context) {
    return Background(
        hasAction: false,
        isHomePage: true,
        fabFunc: () {},
        fabIcon: Icons.qr_code_scanner_outlined,
        isStaff: true,
        hasDrawer: true,
        pageTitle: "Welcome, Staff",
        assetImage: "assets/images/homeStaff.png",
        child: const Center(
          child: Text("Staff Home Page"),
        ));
  }
}
