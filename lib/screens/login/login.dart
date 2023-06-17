import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lugstore/constants/bg.dart';
import 'package:e_lugstore/screens/login/inputField.dart';
import 'package:e_lugstore/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
                            labelText: "Matric No",
                            icondata: Icons.credit_card,
                            controller: matricController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: InputField(
                            labelText: "Password",
                            icondata: Icons.lock,
                            controller: passwordController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: MyButton(
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
      print("not empty");
      setState(() {
        isLoading = true;
      });
      try {
        await FirebaseFirestore.instance.collection('users').get().then(
          (QuerySnapshot querySnapshot) {
            for (var doc in querySnapshot.docs) {
              if (doc['matric no'] == matricController.text.trim()) {
                if (kDebugMode) {
                  print("userinput: ${matricController.text.trim()}");
                  print("db: ${doc['matric no']}");
                  print("email: ${querySnapshot.docs.first['email']}");
                }

                FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: "12345@gmail.com",
                        password: passwordController.text.trim())
                    .then((value) {
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UseerHome()));
                }).catchError((e) {
                  setState(() {
                    isLoading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Invalid credentials"),
                    ),
                  );
                });
              }
            }
          },
        );
      } catch (e) {
        if (kDebugMode) {
          print("Error is: $e");
        }
      }
    }
  }
}
