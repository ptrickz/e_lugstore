import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lugstore/constants/bg.dart';
import 'package:e_lugstore/screens/user/bookingform.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UseerHome extends StatefulWidget {
  const UseerHome({super.key});

  @override
  State<UseerHome> createState() => _UseerHomeState();
}

class _UseerHomeState extends State<UseerHome> {
  @override
  Widget build(BuildContext context) {
    return Background(
        hasAction: false,
        isHomePage: true,
        isStaff: false,
        hasDrawer: true,
        pageTitle: "Booking History",
        assetImage: "assets/images/homeUser.png",
        fabIcon: Icons.add,
        fabFunc: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const BookingForm()));
        },
        child: StreamBuilder(
            stream: readBookings,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Something went wrong"),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }

              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                      "No bookings yet for ${FirebaseAuth.instance.currentUser!.email.toString()}"),
                );
              }

              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return Card(
                    child: ListTile(
                      title: Text(
                          "Luggage on: ${DateTime.parse(data['date'].toDate().toString()).toString().substring(0, 10)}"),
                      subtitle: Text(
                          "at ${DateTime.parse(data['date'].toDate().toString()).toString().substring(11, 16)}"),
                      trailing: Text(
                        data['quantity'],
                        style: TextStyle(color: Colors.green, fontSize: 20),
                      ),
                    ),
                  );
                }).toList(),
              );
            }));
  }

  Stream<QuerySnapshot> get readBookings {
    return FirebaseFirestore.instance
        .collection('bookings')
        .where('email',
            isEqualTo: FirebaseAuth.instance.currentUser!.email.toString())
        .snapshots();
  }
}
