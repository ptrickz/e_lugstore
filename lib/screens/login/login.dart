import 'package:e_lugstore/constants/bg.dart';
import 'package:e_lugstore/screens/login/inputField.dart';
import 'package:e_lugstore/widgets/button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Background(
          hasDrawer: false,
          pageTitle: "Login",
          assetImage: "assets/images/login.png",
          appBarLeading: () {
            Navigator.pop(context);
          },
          icon: Icons.chevron_left,
          child: Center(
              child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage("assets/images/eluggage.png"),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5,
                            offset: Offset(0, 5),
                          ),
                        ]),
                    width: 100,
                    height: 100,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: InputField(
                    labelText: "Matric No.",
                    icondata: Icons.person,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: InputField(
                    labelText: "Password",
                    icondata: Icons.lock,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: MyButton(text: "Login", onPressed: () {}),
                )
              ],
            ),
          ))),
    );
  }
}
