// ignore_for_file: body_might_complete_normally_catch_error

import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mip_app/authentication/login_screeen.dart';
import 'package:mip_app/methods/common_methods.dart';
import 'package:mip_app/pages/home/dashboard.dart';
import 'package:mip_app/splash.dart';
import 'package:mip_app/widgets/loading_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();


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
                height: 40,
              ),
              const SizedBox(
                height: 30,
              ),
              Icon(Icons.lightbulb,size: 200,color: Colors.amber,),
              const Text("Ilumina Braço",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),

              const SizedBox(
                height: 30,
              ),
              const Text("Criar uma nova Conta",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 22,
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(
                      controller: userNameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Seu Nome',
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Fone',
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
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
                        labelText: 'Senha',
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
                        child: const Text('Criar uma Conta')),
                    const SizedBox(
                      height: 22,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => const LoginScreen()));
                        },
                        child: const Text(
                          'Já tenho uma conta! logar agora!',
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


      signUpFormValidation();

  }

  signUpFormValidation() {
    if (userNameController.text.trim() == '') {
      cMethods.displaySnackBar('digite seu nome', context);
    } else if (userNameController.text.trim().length < 3) {
      cMethods.displaySnackBar(
          'nome precisa ser maior que 3 catachters', context);
    } else if (phoneController.text.trim().length < 8) {
      cMethods.displaySnackBar(
          'fone precisa ser maior que 8 catachters', context);
    } else if (passwordController.text.trim().length < 3) {
      cMethods.displaySnackBar(
          'senha precisa ser maior que 3 catachters', context);
    } else if (!emailController.text.trim().contains("@")) {
      cMethods.displaySnackBar('digite um email válido', context);
    }  else {

      registerNewDriver();
    }
  }



  registerNewDriver() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: 'Registrando sua conta....'),
    );
    final User? userFirebase = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim())
            .catchError((e) {
      Navigator.pop(context);
      cMethods.displaySnackBar(e.toString(), context);
    }))
        .user;
    if (!context.mounted) return;
    Navigator.pop(context);

    DatabaseReference usersRef = FirebaseDatabase.instance
        .ref()
        .child('Users')
        .child(userFirebase!.uid);


    Map driversDataMap = {


      "nome": userNameController.text.trim(),
      "email": emailController.text.trim(),
      "fone": phoneController.text.trim(),
      "id": userFirebase.uid,
      "blockStatus": "no",
    };
    usersRef.set(driversDataMap);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        SplashScreen()), (Route<dynamic> route) => false);

  }
}
