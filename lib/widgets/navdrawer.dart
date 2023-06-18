import 'package:e_lugstore/constants/constants.dart';
import 'package:e_lugstore/screens/landing.dart';
import 'package:e_lugstore/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/staff/home.dart';
import '../screens/user/home.dart';

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
            title: Text(widget.isStaff! ? 'Booking List' : 'Booking History'),
            onTap: () {
              widget.isStaff!
                  ? Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StaffHome()))
                  : Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserHome()));
            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfilePage(
                      email: FirebaseAuth.instance.currentUser!.email!)));
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              FirebaseAuth.instance.signOut().whenComplete(() => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LandingPage())));
            },
          ),
        ],
      ),
    );
  }
}
