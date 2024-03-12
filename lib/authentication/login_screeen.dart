// ignore_for_file: body_might_complete_normally_catch_error

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/authentication/signup_screen.dart';
import 'package:mip_app/controllers/loginControllers.dart';
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

  final LoginController conLog = Get.put(LoginController());
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
                      controller: conLog.emailController,
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
                      controller: conLog.passwordController,
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
                          conLog.checkNetworkIsAvailable(context);
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






}
