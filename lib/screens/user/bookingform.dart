import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lugstore/constants/bg.dart';
import 'package:e_lugstore/screens/login/inputfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BookingForm extends StatefulWidget {
  const BookingForm({super.key});

  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final TextEditingController nameController = TextEditingController(
      text: FirebaseAuth.instance.currentUser!.displayName!);
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController dateController =
      TextEditingController(text: DateTime.now().toString().substring(0, 16));
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Background(
                pageTitle: "Booking Form",
                assetImage: "assets/images/login.png",
                hasDrawer: false,
                isHomePage: false,
                hasAction: false,
                child: Center(child: CircularProgressIndicator()));
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Background(
                hasAction: true,
                actionIcon: Icons.check,
                actionButtonFunc: () {
                  createBooking(
                    user: nameController.text.trim(),
                    matricNo: snapshot.data![0]['matric no'],
                    quantity: quantityController.text.trim(),
                    date: DateTime.parse(dateController.text.trim()),
                    status: "Pending",
                  ).then((value) => Navigator.pop(context));
                },
                appBarLeading: () {
                  Navigator.pop(context);
                },
                icon: Icons.close,
                isHomePage: false,
                isStaff: false,
                pageTitle: "Booking Form",
                assetImage: "assets/images/booking.png",
                hasDrawer: false,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InputField(
                              hasInitValue: false,
                              labelText: "Name",
                              icondata: Icons.person,
                              controller: nameController,
                              isAuthField: false,
                              keyboardType: TextInputType.name,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InputField(
                              hasInitValue: false,
                              labelText: "Matric No.",
                              icondata: Icons.credit_card,
                              controller: TextEditingController(
                                  text: snapshot.data![0]['matric no']),
                              isAuthField: false,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: InputField(
                                hasInitValue: false,
                                labelText: "Quantity",
                                icondata: Icons.numbers,
                                controller: quantityController,
                                isAuthField: false,
                                keyboardType: TextInputType.number,
                              )),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InputField(
                              hasInitValue: false,
                              isEnabled: false,
                              labelText: "Date",
                              icondata: Icons.calendar_month,
                              controller: dateController,
                              isAuthField: false,
                              keyboardType: TextInputType.datetime,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
          } else {
            return Background(
                pageTitle: "Booking Form",
                assetImage: "assets/images/login.png",
                hasDrawer: false,
                isHomePage: false,
                hasAction: false,
                icon: Icons.close,
                appBarLeading: () {
                  Navigator.pop(context);
                },
                child: const Center(child: Text("Something went wrong")));
          }
        });
  }

  Future get users async {
    final user = FirebaseAuth.instance.currentUser!.email;
    final docUser = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user)
        .limit(1);
    final snapshot = await docUser.get();
    return snapshot.docs;
  }

  Future createBooking({
    required String user,
    required String matricNo,
    required String quantity,
    required DateTime date,
    required String status,
  }) async {
    String time = DateTime.now()
        .toString()
        .substring(10, 19)
        .replaceAll(" ", "")
        .replaceAll(":", "");
    String dateId = DateTime.now().toString().substring(0, 10);
    //refer doc
    final docBooking = FirebaseFirestore.instance
        .collection('bookings')
        .doc("L$matricNo-$dateId-$time");
    final booking = Bookings(
      email: FirebaseAuth.instance.currentUser!.email!,
      user: user,
      matricNo: matricNo,
      quantity: quantity,
      date: date,
      id: ("L$matricNo-$dateId-$time"),
      status: status,
    );
    final json = booking.toJson();
    try {
      await docBooking.set(json);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}

class Bookings {
  final String user;
  final String matricNo;
  final String quantity;
  final DateTime date;
  final String email;
  final String id;
  final String status;

  Bookings({
    required this.email,
    required this.user,
    required this.matricNo,
    required this.quantity,
    required this.date,
    required this.id,
    required this.status,
  });

  factory Bookings.fromJson(Map<String, dynamic> json) {
    return Bookings(
        user: json['user'],
        matricNo: json['matric no'],
        quantity: json['quantity'],
        email: json['email'],
        date: json['date'],
        status: json['status'],
        id: json['id']);
  }
  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'matric no': matricNo,
      'quantity': quantity,
      'date': date,
      'email': email,
      'id': id,
      'status': status,
    };
  }
}
