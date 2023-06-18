import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lugstore/constants/bg.dart';
import 'package:e_lugstore/widgets/button.dart';
import 'package:flutter/material.dart';

import '../login/inputField.dart';

class BookingDetails extends StatefulWidget {
  final String? documentId;
  final bool? isStaff;
  const BookingDetails(
      {super.key, required this.documentId, required this.isStaff});

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  TextEditingController quantityController = TextEditingController();
  bool isEditing = false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: readBookings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Background(
                pageTitle: "Booking Details",
                assetImage: "assets/images/login.png",
                hasDrawer: false,
                isHomePage: false,
                hasAction: false,
                child: Center(child: CircularProgressIndicator()));
          } else if (snapshot.connectionState == ConnectionState.done) {}
          return Background(
              icon: isEditing ? Icons.close : Icons.chevron_left,
              appBarLeading: () {
                isEditing
                    ? setState(() {
                        isEditing = false;
                      })
                    : Navigator.pop(context);
              },
              pageTitle: isEditing ? "Edit Details" : "Booking Details",
              assetImage: "assets/images/login.png",
              hasDrawer: false,
              isHomePage: false,
              hasAction: true,
              actionIcon: widget.isStaff == true
                  ? null
                  : snapshot.data!.docs[0]['status'] == "Pending"
                      ? isEditing
                          ? Icons.save
                          : Icons.edit_document
                      : null,
              actionButtonFunc: () {
                final docBooking = FirebaseFirestore.instance
                    .collection('bookings')
                    .doc(widget.documentId);
                isEditing
                    ? docBooking.update({
                        'quantity': quantityController.text.trim(),
                      }).then((value) => setState(() {
                          isEditing = false;
                        }))
                    : setState(() {
                        isEditing = true;
                      });
              },
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: widget.isStaff == true
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30.0,
                                        right: 30.0,
                                        top: 10.0,
                                        bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Name: ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          snapshot.data!.docs[0]['user'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30.0,
                                        right: 30.0,
                                        top: 10.0,
                                        bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Quantity: ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          snapshot.data!.docs[0]['quantity'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30.0,
                                        right: 30.0,
                                        top: 10.0,
                                        bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Date: ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          DateTime.parse(snapshot
                                                  .data!.docs[0]['date']
                                                  .toDate()
                                                  .toString())
                                              .toString()
                                              .substring(0, 10),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30.0,
                                        right: 30.0,
                                        top: 10.0,
                                        bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Status: ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          snapshot.data!.docs[0]['status'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(top: 100.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: 30.0,
                                              right: 30.0,
                                              top: 10.0,
                                              bottom: 10),
                                          child: MyButton(
                                              isRed: false,
                                              text: "Approve",
                                              onPressed: () {
                                                final docBooking =
                                                    FirebaseFirestore.instance
                                                        .collection('bookings')
                                                        .doc(widget.documentId);
                                                docBooking.update({
                                                  'status': "Approved",
                                                });
                                              })),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: 30.0,
                                              right: 30.0,
                                              top: 10.0,
                                              bottom: 10),
                                          child: MyButton(
                                              isRed: true,
                                              text: "Reject",
                                              onPressed: () {
                                                final docBooking =
                                                    FirebaseFirestore.instance
                                                        .collection('bookings')
                                                        .doc(widget.documentId);
                                                docBooking.update({
                                                  'status': "Rejected",
                                                });
                                              })),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : isEditing
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: InputField(
                                        hasInitValue: false,
                                        isEnabled: false,
                                        labelText: "ID",
                                        icondata: Icons.dashboard,
                                        controller: TextEditingController(
                                            text: snapshot.data!.docs[0]['id']),
                                        isAuthField: false,
                                        keyboardType: TextInputType.name,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: InputField(
                                        hasInitValue: false,
                                        isEnabled: false,
                                        labelText: "Name",
                                        icondata: Icons.person,
                                        controller: TextEditingController(
                                            text: snapshot.data!.docs[0]
                                                ['user']),
                                        isAuthField: false,
                                        keyboardType: TextInputType.name,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: InputField(
                                        hasInitValue: false,
                                        isEnabled: false,
                                        labelText: "Matric No.",
                                        icondata: Icons.credit_card,
                                        controller: TextEditingController(
                                            text: snapshot.data!.docs[0]
                                                ['matric no']),
                                        isAuthField: false,
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: InputField(
                                          hasInitValue: true,
                                          labelText: "Quantity",
                                          isEnabled: true,
                                          icondata: Icons.numbers,
                                          controller: isEditing
                                              ? quantityController
                                              : TextEditingController(
                                                  text: snapshot.data!.docs[0]
                                                      ['quantity']),
                                          isAuthField: false,
                                          keyboardType: TextInputType.number,
                                        )),
                                  ],
                                )
                              : Column(
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
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 30.0,
                                            right: 30.0,
                                            top: 10.0,
                                            bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Name: ",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              snapshot.data!.docs[0]['user'],
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 30.0,
                                            right: 30.0,
                                            top: 10.0,
                                            bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Quantity: ",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              snapshot.data!.docs[0]
                                                  ['quantity'],
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 30.0,
                                            right: 30.0,
                                            top: 10.0,
                                            bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Date: ",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              DateTime.parse(snapshot
                                                      .data!.docs[0]['date']
                                                      .toDate()
                                                      .toString())
                                                  .toString()
                                                  .substring(0, 10),
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 30.0,
                                            right: 30.0,
                                            top: 10.0,
                                            bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Status: ",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              snapshot.data!.docs[0]['status'],
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )),
                                  ],
                                )),
                ),
              ));
        });
  }

  Stream<QuerySnapshot> get readBookings {
    return FirebaseFirestore.instance
        .collection('bookings')
        .where('id', isEqualTo: widget.documentId)
        .snapshots();
  }
}
