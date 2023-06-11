import 'package:e_lugstore/constants/constants.dart';
import 'package:flutter/material.dart';

import '../screens/landing.dart';

class NavDrawer extends StatefulWidget {
  final bool? isStaff;
  const NavDrawer({
    super.key,
    required this.isStaff,
  });

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              child: Center(
                  child: CircleAvatar(
            radius: 50,
            backgroundColor: accent,
            child: const Center(
                child: Icon(
              Icons.person,
              size: 40,
              color: Colors.white,
            )),
          ))),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(widget.isStaff! ? 'Booking List' : 'Booking History'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LandingPage()));
            },
          ),
        ],
      ),
    );
  }
}
