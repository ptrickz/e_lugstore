import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lugstore/screens/staff/home.dart';
import 'package:e_lugstore/screens/user/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: readUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(28.0),
                      child: CircularProgressIndicator.adaptive(),
                    ),
                    Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Text("Authenticating..."),
                    )
                  ],
                ),
              ),
            );
          } else if (snapshot.data!.docs[0]['staff']) {
            return const StaffHome();
          } else {
            return const UserHome();
          }
        });
  }

  Stream<QuerySnapshot> get readUser {
    return FirebaseFirestore.instance
        .collection('users')
        .where('email',
            isEqualTo: FirebaseAuth.instance.currentUser!.email.toString())
        .snapshots();
  }
}
