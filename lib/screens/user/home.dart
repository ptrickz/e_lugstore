import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lugstore/constants/bg.dart';
import 'package:e_lugstore/screens/user/bookingform.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'bookingdetails.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  @override
  Widget build(BuildContext context) {
    return Background(
        hasAction: false,
        isHomePage: true,
        isStaff: false,
        hasDrawer: true,
        pageTitle: "Welcome, ${FirebaseAuth.instance.currentUser!.displayName}",
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
                return const Center(
                  child: Text("No bookings yet."),
                );
              }

              return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: ListView(
                    shrinkWrap: true,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BookingDetails(
                                    isStaff: false,
                                    documentId: data['id'],
                                  )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: ListTile(
                              title: Text(
                                data['id'],
                              ),
                              subtitle: Text(
                                  "booked on ${DateTime.parse(data['date'].toDate().toString()).toString().substring(0, 10)}"),
                              trailing: Text(
                                data['quantity'],
                                style: const TextStyle(
                                    color: Colors.green, fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
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
