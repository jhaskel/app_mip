

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/global/global_var.dart';
import 'package:mip_app/methods/common_methods.dart';

class UsuarioController extends GetxController{

  final ref = FirebaseDatabase.instance.ref('Users');
  CommonMethods cMethods = CommonMethods();

  userCurrent(BuildContext context) async{

    final User? userFirebase = (await FirebaseAuth.instance.currentUser);

    DatabaseReference usersRef = FirebaseDatabase.instance
        .ref()
        .child("Users")
        .child(userFirebase!.uid);
    usersRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        if ((snap.snapshot.value as Map)["blockStatus"] == "no") {
          userName = (snap.snapshot.value as Map)["nome"];
          userRole = (snap.snapshot.value as Map)["role"];
        } else {
          FirebaseAuth.instance.signOut();
          cMethods.displaySnackBar(
              "you está bloqueado. Contate o admin: 2bitsw@gmail.com", context);
        }
      } else {
        FirebaseAuth.instance.signOut();
        cMethods.displaySnackBar(
            "Seu email não consta em nosso sistema.", context);
      }
    });
  }

}