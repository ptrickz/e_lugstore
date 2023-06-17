import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lugstore/constants/bg.dart';
import 'package:e_lugstore/constants/constants.dart';
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
  final TextEditingController matricController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController dateController =
      TextEditingController(text: DateTime.now().toString().substring(0, 16));
  @override
  Widget build(BuildContext context) {
    return Background(
        hasAction: true,
        actionIcon: Icons.check,
        actionButtonFunc: () {
          createBooking(
            user: nameController.text.trim(),
            matricNo: matricController.text.trim(),
            quantity: quantityController.text.trim(),
            date: DateTime.parse(dateController.text.trim()),
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
                    padding: const EdgeInsets.only(
                      top: 28.0,
                      bottom: 28.0,
                    ),
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey,
                      child: const Center(
                        child: Text("QR"),
                      ),
                    ),
                  ),
                  Text(
                    "*Note: QR Code will be auto-generated when saved.",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: accent,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InputField(
                      labelText: "Name",
                      icondata: Icons.person,
                      controller: nameController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InputField(
                      labelText: "Matric No.",
                      icondata: Icons.credit_card,
                      controller: matricController,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InputField(
                        labelText: "Quantity",
                        icondata: Icons.numbers,
                        controller: quantityController,
                      )),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InputField(
                      labelText: "Date",
                      icondata: Icons.calendar_month,
                      controller: dateController,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future createBooking({
    required String user,
    required String matricNo,
    required String quantity,
    required DateTime date,
  }) async {
    //refer doc
    final docBooking =
        FirebaseFirestore.instance.collection('bookings').doc(matricNo);
    final booking = Bookings(
      email: FirebaseAuth.instance.currentUser!.email!,
      user: user,
      matricNo: matricNo,
      quantity: quantity,
      date: date,
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

  Bookings({
    required this.email,
    required this.user,
    required this.matricNo,
    required this.quantity,
    required this.date,
  });

  factory Bookings.fromJson(Map<String, dynamic> json) {
    return Bookings(
      user: json['user'],
      matricNo: json['matric no'],
      quantity: json['quantity'],
      email: json[FirebaseAuth.instance.currentUser!.email!],
      date: json['date'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'matric no': matricNo,
      'quantity': quantity,
      'date': date,
      'email': email,
    };
  }
}
