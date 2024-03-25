
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mip_app/authentication/login_screeen.dart';
import 'package:mip_app/global/global_var.dart';
import 'package:mip_app/methods/common_methods.dart';
import 'package:mip_app/pages/home/dashboard.dart';
import 'package:mip_app/splash.dart';

import '../widgets/loading_dialog.dart';
import 'package:get/get.dart';




class LoginController extends GetxController {

  var auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  CommonMethods cMethods = CommonMethods();

  clear(){
    emailController.clear();
    passwordController.clear();
  }





  void checkNetworkIsAvailable(BuildContext context) {
    cMethods.checkConnectivity(context);
    signInFormValidation(context);
  }
  signInFormValidation(BuildContext context) {
    if (!emailController.text.trim().contains("@")) {
      cMethods.displaySnackBar('digite um email válido', context);
    } else if (passwordController.text.trim().length < 3) {
      cMethods.displaySnackBar(
          'senha precisa ser maior que 3 catachters', context);
    } else {
      signInUser(context);
    }
  }


  signInUser(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "LOGANDO EM SUA CONTA..."),
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

    if (userFirebase != null) {
      DatabaseReference usersRef = FirebaseDatabase.instance
          .ref()
          .child("Users")
          .child(userFirebase.uid);
      usersRef.once().then((snap) {
        if (snap.snapshot.value != null) {
          if ((snap.snapshot.value as Map)["blockStatus"] == "no") {
            userName = (snap.snapshot.value as Map)["nome"];
            userRole = (snap.snapshot.value as Map)["role"];
            clear();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (c) => SplashScreen()));
          } else {
            auth.signOut();
            cMethods.displaySnackBar(
                "you está bloqueado. Contate o admin: 2bitsw@gmail.com", context);
          }
        } else {
          auth.signOut();
          cMethods.displaySnackBar(
              "Seu email não consta em nosso sistema.", context);
        }
      });
    }

    Navigator.pop(context);

  }
  
  logout(BuildContext context) async {
   await auth.signOut();
   userName="";
   userRole="";
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => LoginScreen()), (
        route) => false);

  }


}
