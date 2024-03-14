

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/global/global_var.dart';
import 'package:mip_app/methods/common_methods.dart';
import 'package:mip_app/pages/dashboard.dart';
import 'package:mip_app/widgets/loading_dialog.dart';

class UsuarioController extends GetxController{

  final ref = FirebaseDatabase.instance.ref('Users');
  CommonMethods cMethods = CommonMethods();
  List<dynamic> listUsuarios = [].obs;
  var textPage = "Usuários".obs;
  var textPageCreate = 'Adicionar um Novo Usuário'.obs;
  var role = "user".obs;



  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

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
              "você está bloqueado. Contate o admin: 2bitsw@gmail.com", context);
        }
      } else {
        FirebaseAuth.instance.signOut();
        cMethods.displaySnackBar(
            "Seu email não consta em nosso sistema.", context);
      }
    });
  }

  getUsuarios(BuildContext context,) async {

    await ref.onValue.listen((event) {
      listUsuarios.clear();
      if (event.snapshot.exists) {
        Map pos = event.snapshot.value as Map;
        listUsuarios.clear();
        listUsuarios = pos.values.toList();
      }
    });
    update();
  }

  void checkNetworkIsAvailable(BuildContext context) {
    cMethods.checkConnectivity(context);
    signUpFormValidation(context);
  }

  signUpFormValidation(BuildContext context) {
    if (userNameController.text.trim() == '') {
      cMethods.displaySnackBar('digite o nome do usuário', context);
    } else if (userNameController.text.trim().length < 3) {
      cMethods.displaySnackBar(
          'nome precisa ser maior que 3 caracteres', context);
    } else if (phoneController.text.trim().length <10) {
      cMethods.displaySnackBar(
          'fone precisa ser maior que 11 caracteres', context);
    } else if (passwordController.text.trim().length < 3) {
      cMethods.displaySnackBar(
          'senha precisa ser maior que 3 caracteres', context);
    } else if (!emailController.text.trim().contains("@")) {
      cMethods.displaySnackBar('digite um email válido', context);

    } else {
     register(context);

    }
  }

  register(BuildContext context) async {
    var uid ="";
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: 'Registrando sua Conta....'),
    );
     await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim()).then((value) {

         uid = value.user!.uid;
          print("value ${value.user!.uid}");
          print("nome $userName");

         Map driversDataMap = {
           "nome": userNameController.text.trim(),
           "email": emailController.text.trim(),
           "phone": phoneController.text.trim(),
           "id": uid,
           "blockStatus": "no",
           "role": role.value,
         };

         FirebaseDatabase.instance
             .ref()
             .child('Users')
             .child(uid).set(driversDataMap);

         if (!context.mounted) return;
        print("xxxxxxxxxxxxxxxxxxxxxxxxccccccccccccccccccccccccccc");
         getUsuarios(context);
         update();

         Navigator.pop(context);

    })
        .catchError((e) {
      Navigator.pop(context);
      cMethods.displaySnackBar(e.toString(), context);
    });

update();

  }




}