import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lugstore/constants/bg.dart';
import 'package:e_lugstore/screens/login/inputfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController matricController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Background(
        isHomePage: false,
        hasAction: false,
        hasDrawer: false,
        pageTitle: "Sign Up",
        assetImage: "assets/images/signup.png",
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
                      child: Text("Signing up..."),
                    )
                  ],
                ),
              )
            : GestureDetector(
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
                            padding: const EdgeInsets.fromLTRB(55, 20, 55, 20),
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/eluggage.png"),
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
                              labelText: "Name",
                              icondata: Icons.person,
                              controller: nameController,
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
                              labelText: "Email",
                              icondata: Icons.email,
                              controller: emailController,
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
                                  text: "Sign Up",
                                  onPressed: () {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    signUp(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                      matricNo: matricController.text.trim(),
                                      name: nameController.text.trim(),
                                    ).then((value) {
                                      setState(() {
                                        FirebaseAuth.instance.currentUser!
                                            .updateDisplayName(
                                                nameController.text.trim());
                                        isLoading = false;
                                      });
                                      Navigator.pop(context);
                                    });
                                  }))
                        ],
                      )),
                ),
              ));
  }

  Future signUp({
    required String email,
    required String password,
    required String matricNo,
    required String name,
  }) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await FirebaseFirestore.instance.collection("users").doc(matricNo).set({
      "name": name,
      "matric no": matricNo,
      "email": email,
      "staff": false,
    });
  }
}
