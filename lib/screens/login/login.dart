import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lugstore/constants/bg.dart';
import 'package:e_lugstore/screens/login/inputField.dart';
import 'package:e_lugstore/screens/staff/home.dart';
import 'package:e_lugstore/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../user/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController matricController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    matricController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  alertBox(String title, String message) async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("OK"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Background(
          hasAction: false,
          isHomePage: false,
          hasDrawer: false,
          pageTitle: "Login",
          assetImage: "assets/images/login.png",
          appBarLeading: () {
            Navigator.pop(context);
          },
          icon: Icons.chevron_left,
          child: isLoading
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(28.0),
                        child: CircularProgressIndicator.adaptive(),
                      ),
                      Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text("Logging in..."),
                      )
                    ],
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(55, 20, 55, 20),
                          child: Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/eluggage.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            width: 100,
                            height: 100,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: InputField(
                            hasInitValue: false,
                            labelText: "Matric No",
                            icondata: Icons.credit_card,
                            controller: matricController,
                            isAuthField: false,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: InputField(
                            hasInitValue: false,
                            labelText: "Password",
                            icondata: Icons.lock,
                            controller: passwordController,
                            isAuthField: false,
                            keyboardType: TextInputType.visiblePassword,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: MyButton(
                            isRed: false,
                            text: "Login",
                            onPressed: signIn,
                          ),
                        )
                      ],
                    ),
                  )),
                )),
    );
  }

  Future signIn() async {
    if (matricController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields"),
        ),
      );
    } else {
      setState(() {
        isLoading = true;
      });
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(matricController.text.trim())
            .get()
            .then((doc) {
          if (doc.exists) {
            FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: doc['email'], password: passwordController.text)
                .then((value) {
              setState(() {
                isLoading = false;
              });
              doc['staff'] == true
                  ? Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StaffHome()))
                  : Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserHome()));
            }).catchError((e) {
              setState(() {
                isLoading = false;
              });
              alertBox("Wrong Credentials!",
                  "Wrong password or matric no, try again");
            });
          } else if (!doc.exists) {
            setState(() {
              isLoading = false;
            });
            alertBox("No such user!", "Please sign up first");
          } else {
            setState(() {
              isLoading = false;
            });
            alertBox("Connection Error!", "Please try again later");
          }
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }
}
