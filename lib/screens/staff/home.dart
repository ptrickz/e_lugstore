import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lugstore/constants/bg.dart';
import 'package:e_lugstore/screens/staff/qrscanner.dart';
import 'package:flutter/material.dart';
import '../user/bookingdetails.dart';

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
        isStaff: true,
        hasDrawer: true,
        pageTitle: "Booking Lists",
        assetImage: "assets/images/homeStaff.png",
        fabIcon: Icons.qr_code_scanner,
        fabFunc: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const QRScanner()));
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
                                    isStaff: true,
                                    documentId: data['id'],
                                  )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Card(
                            child: ListTile(
                              title: Text(
                                data['id'],
                              ),
                              subtitle: Text(
                                  "booked on ${DateTime.parse(data['date'].toDate().toString()).toString().substring(0, 10)} \n${data['status']}"),
                              trailing: Text(
                                data['quantity'].toString(),
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
    return FirebaseFirestore.instance.collection('bookings').snapshots();
  }
}
