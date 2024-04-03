import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/authentication/login_screeen.dart';

import 'package:mip_app/controllers/usuarioController.dart';
import 'package:mip_app/global/global_var.dart';

import 'package:mip_app/pages/home/dashboard.dart';
import 'package:mip_app/pages/home/dashboard_anonimo.dart';
import 'package:mip_app/pages/home/dashboard_operador.dart';
import 'package:mip_app/pages/home/dashboard_supervisor.dart';

class SplashServices {
  UsuarioController conUse = Get.put(UsuarioController());
  void isLogin(BuildContext context) async {
    final auth = FirebaseAuth.instance;

    await conUse.userCurrent(context);
    final user = auth.currentUser;

    print("userRole $userRole");

    if (user != null) {
      if (userRole == "user") {
        Timer(
            const Duration(seconds: 2),
            () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardAnonimo()),
                ));
      }
      else if  (userRole == "operador") {
        Timer(
            const Duration(seconds: 2),
            () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardOperador()),
                ));
      } else if (userRole == "supervisor") {
        Timer(
            const Duration(seconds: 2),
            () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DashboardSupervisor()),
                ));
      } else if (userRole == "admin") {
        Timer(
            const Duration(seconds: 2),
            () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                ));
      } else if (userRole == "master") {
        Timer(
            const Duration(seconds: 2),
            () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                ));
      } else if (userRole == "dev") {
        Timer(
            const Duration(seconds: 2),
            () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                ));
      } else {
        Timer(
            const Duration(seconds: 2),
            () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                ));
      }
    } else {

      Timer(
          const Duration(seconds: 2),
          () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DashboardAnonimo()),
              ));
    }
  }
}
