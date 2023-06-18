import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lugstore/constants/bg.dart';
import 'package:e_lugstore/screens/user/home.dart';
import 'package:e_lugstore/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
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

  alertBox(String title, String message, VoidCallback onPressed) async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                TextButton(onPressed: onPressed, child: const Text("OK"))
              ],
            ));
  }

  viewQR(Widget message) async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: message,
            ));
  }

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
          }

          if (snapshot.hasError) {
            return const Background(
                pageTitle: "Booking Details",
                assetImage: "assets/images/login.png",
                hasDrawer: false,
                isHomePage: false,
                hasAction: false,
                child: Center(child: Text("Something went wrong")));
          }
          if (!snapshot.hasData) {
            return const Background(
                pageTitle: "Booking Details",
                assetImage: "assets/images/login.png",
                hasDrawer: false,
                isHomePage: false,
                hasAction: false,
                child: Center(
                    child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 30,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Item has successfully checked out."),
                    )
                  ],
                )));
          }
          if (snapshot.hasData) {
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
                                  snapshot.data!.docs[0]['status'] == "Pending"
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 100.0),
                                          child: Column(
                                            children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 30.0,
                                                          right: 30.0,
                                                          top: 10.0,
                                                          bottom: 10),
                                                  child: MyButton(
                                                      isRed: false,
                                                      text: "Approve",
                                                      onPressed: () {
                                                        alertBox(
                                                            "Approve Booking?",
                                                            "Click OK to approve Booking: \n${widget.documentId}",
                                                            () {
                                                          final docBooking =
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'bookings')
                                                                  .doc(widget
                                                                      .documentId);
                                                          docBooking.update({
                                                            'status':
                                                                "Approved",
                                                          }).then((value) =>
                                                              Navigator.pop(
                                                                  context));
                                                        });
                                                      })),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 30.0,
                                                          right: 30.0,
                                                          top: 10.0,
                                                          bottom: 10),
                                                  child: MyButton(
                                                      isRed: true,
                                                      text: "Reject",
                                                      onPressed: () {
                                                        alertBox(
                                                            "Reject Booking?",
                                                            "Click OK to reject Booking: \n${widget.documentId}",
                                                            () {
                                                          final docBooking =
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'bookings')
                                                                  .doc(widget
                                                                      .documentId);
                                                          docBooking.update({
                                                            'status':
                                                                "Rejected",
                                                          }).then((value) =>
                                                              Navigator.pop(
                                                                  context));
                                                        });
                                                      })),
                                            ],
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              )
                            : isEditing
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: InputField(
                                          isPassword: false,
                                          hasInitValue: false,
                                          isEnabled: false,
                                          labelText: "ID",
                                          icondata: Icons.dashboard,
                                          controller: TextEditingController(
                                              text: snapshot.data!.docs[0]
                                                  ['id']),
                                          isAuthField: false,
                                          keyboardType: TextInputType.name,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: InputField(
                                          isPassword: false,
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
                                          isPassword: false,
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
                                            isPassword: false,
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
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 100.0),
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 30.0,
                                                right: 30.0,
                                                top: 10.0,
                                                bottom: 10),
                                            child: MyButton(
                                                isRed: true,
                                                text: "Delete Booking",
                                                onPressed: () {
                                                  alertBox("Delete Booking?",
                                                      "Are you sure you want to delete this booking?",
                                                      () {
                                                    final docBooking =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'bookings')
                                                            .doc(widget
                                                                .documentId);
                                                    Navigator.of(context);
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const UserHome()));
                                                    docBooking.delete();
                                                  });
                                                })),
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      snapshot.data!.docs[0]['status'] ==
                                              "Approved"
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 28.0,
                                              ),
                                              child: Column(
                                                children: [
                                                  const Text(
                                                    "Checkout QR:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    height: 200,
                                                    color: Colors.white,
                                                    child: Center(
                                                        child: QrImageView(
                                                            data: snapshot.data!
                                                                    .docs[0]
                                                                ['id'])),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 28.0,
                                              ),
                                              child: Column(
                                                children: [
                                                  const Text(
                                                    "Checkout QR:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Container(
                                                      width: 200,
                                                      height: 200,
                                                      color: Colors.grey,
                                                      child: const Center(
                                                          child: Text(
                                                        "Pending Staff Approval",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ))),
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
                                                "Name: ",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                snapshot.data!.docs[0]['user'],
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                snapshot.data!.docs[0]
                                                    ['quantity'],
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                snapshot.data!.docs[0]
                                                    ['status'],
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          )),
                                      snapshot.data!.docs[0]
                                                  ['checkoutConfirmation'] ==
                                              "Pending User Confirmation"
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 100.0),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 30.0,
                                                              right: 30.0,
                                                              top: 10.0,
                                                              bottom: 10),
                                                      child: MyButton(
                                                          isRed: false,
                                                          text:
                                                              "Confirm Checkout",
                                                          onPressed: () {
                                                            final docBooking =
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'bookings')
                                                                    .doc(widget
                                                                        .documentId);
                                                            Navigator.pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const UserHome()));
                                                            docBooking.delete();
                                                          })),
                                                ],
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  )),
                  ),
                ));
          }
          return const SizedBox.shrink();
        });
  }

  Stream<QuerySnapshot> get readBookings {
    return FirebaseFirestore.instance
        .collection('bookings')
        .where('id', isEqualTo: widget.documentId)
        .snapshots();
  }
}
