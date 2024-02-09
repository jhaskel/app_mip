// ignore_for_file: body_might_complete_normally_catch_error

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mip_app/authentication/signup_screen.dart';
import 'package:mip_app/global/global_var.dart';
import 'package:mip_app/methods/common_methods.dart';
import 'package:mip_app/pages/dashboard.dart';
import 'package:mip_app/widgets/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  CommonMethods cMethods = CommonMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Image.asset(
                'assets/images/uberexec.png',
                width: 220,
              ),
              const SizedBox(
                height: 30,
              ),
              const Text("Login as Driver",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 22,
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 22,
                    ),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    TextField(
                      controller: passwordController,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 44,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          checkNetworkIsAvailable();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 80, vertical: 10)),
                        child: const Text('Login')),
                    const SizedBox(
                      height: 22,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => const SignupScreen()));
                        },
                        child: const Text(
                          "Don't have an Account? Register here",
                          style: TextStyle(color: Colors.grey),
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void checkNetworkIsAvailable() {
    cMethods.checkConnectivity(context);
    signInFormValidation();
  }

  signInFormValidation() {
    if (!emailController.text.trim().contains("@")) {
      cMethods.displaySnackBar('digite um email válido', context);
    } else if (passwordController.text.trim().length < 3) {
      cMethods.displaySnackBar(
          'senha precisa ser maior que 3 catachters', context);
    } else {
      signInUser();
    }
  }

  signInUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "Allowing you to Login..."),
    );

    final User? userFirebase = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
            .catchError((errorMsg) {
      Navigator.pop(context);
      cMethods.displaySnackBar(errorMsg.toString(), context);
    }))
        .user;

    if (!context.mounted) return;
    Navigator.pop(context);

    if (userFirebase != null) {
      DatabaseReference usersRef = FirebaseDatabase.instance
          .ref()
          .child("drivers")
          .child(userFirebase.uid);
      usersRef.once().then((snap) {
        if (snap.snapshot.value != null) {
          if ((snap.snapshot.value as Map)["blockStatus"] == "no") {
            userName = (snap.snapshot.value as Map)["name"];
            Navigator.push(
                context, MaterialPageRoute(builder: (c) => Dashboard()));
          } else {
            FirebaseAuth.instance.signOut();
            cMethods.displaySnackBar(
                "you are blocked. Contact admin: alizeb875@gmail.com", context);
          }
        } else {
          FirebaseAuth.instance.signOut();
          cMethods.displaySnackBar(
              "your record do not exists as a Driver.", context);
        }
      });
    }
  }
}
