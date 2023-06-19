import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lugstore/constants/constants.dart';
import 'package:e_lugstore/screens/login/inputfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/bg.dart';

class ProfilePage extends StatefulWidget {
  final String? email;
  const ProfilePage({
    super.key,
    this.email,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;
  final TextEditingController pwController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: readProfile,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Background(
              pageTitle: "Profile",
              assetImage: "assets/images/profile.png",
              hasDrawer: false,
              isHomePage: false,
              hasAction: false,
              child: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError) {
          return const Background(
              pageTitle: "Profile",
              assetImage: "assets/images/profile.png",
              hasDrawer: false,
              isHomePage: false,
              hasAction: false,
              child: Center(child: Text("Something went wrong")));
        }

        return Background(
            pageTitle: "Profile",
            assetImage: "assets/images/profile.png",
            isStaff: snapshot.data!.docs[0]['staff'],
            hasDrawer: !isEditing,
            icon: isEditing ? Icons.close : Icons.menu,
            appBarLeading: isEditing
                ? () {
                    setState(() {
                      isEditing = false;
                    });
                  }
                : () {
                    Navigator.pop(context);
                  },
            isHomePage: false,
            hasAction: true,
            actionIcon: isEditing ? Icons.check : Icons.edit_document,
            actionButtonFunc: () {
              if (isEditing) {
                final user = FirebaseFirestore.instance
                    .collection('users')
                    .where('email', isEqualTo: widget.email)
                    .get();
                user.then((user) {
                  for (var element in user.docs) {
                    element.reference.update({
                      'name': nameController.text.trim(),
                    });
                  }
                });
                if (pwController.text.trim() != "") {
                  FirebaseAuth.instance.currentUser!
                      .updatePassword(pwController.text.trim());
                }
                setState(() {
                  isEditing = false;
                });
              } else {
                setState(() {
                  isEditing = true;
                });
              }
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(55, 20, 55, 20),
                  child: Container(
                    decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(100)),
                    width: 100,
                    height: 100,
                    child: const Center(
                        child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    snapshot.data!.docs[0]['staff'] == true
                        ? "Role: Staff"
                        : "Role: Student",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InputField(
                      isPassword: false,
                      isEnabled: isEditing,
                      isAuthField: false,
                      keyboardType: TextInputType.name,
                      labelText: "Name",
                      icondata: Icons.person,
                      controller: isEditing
                          ? nameController
                          : TextEditingController(
                              text: snapshot.data!.docs[0]['name']),
                      hasInitValue: false),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InputField(
                      isPassword: false,
                      isAuthField: false,
                      isEnabled: false,
                      keyboardType: TextInputType.name,
                      labelText: "Matric No/Staff No",
                      icondata: Icons.credit_card,
                      controller: TextEditingController(
                        text: snapshot.data!.docs[0]['matric no'],
                      ),
                      hasInitValue: false),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InputField(
                      isPassword: false,
                      isAuthField: false,
                      isEnabled: false,
                      keyboardType: TextInputType.name,
                      labelText: "Email",
                      icondata: Icons.email,
                      controller: TextEditingController(
                        text: snapshot.data!.docs[0]['email'],
                      ),
                      hasInitValue: false),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InputField(
                      isPassword: true,
                      isAuthField: false,
                      isEnabled: isEditing,
                      keyboardType: TextInputType.name,
                      labelText: "Password",
                      icondata: Icons.lock,
                      controller: isEditing
                          ? pwController
                          : TextEditingController(text: "*********"),
                      hasInitValue: false),
                ),
              ],
            ));
      },
    );
  }

  Stream get readProfile {
    return FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: widget.email)
        .snapshots();
  }
}
