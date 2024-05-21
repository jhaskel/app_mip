import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/global/global_var.dart';
import 'package:mip_app/methods/common_methods.dart';

import 'package:mip_app/widgets/loading_dialog.dart';

class UsuarioController extends GetxController {
  final ref = FirebaseDatabase.instance.ref('Users');
  CommonMethods cMethods = CommonMethods();
  List<dynamic> listUsuarios = [].obs;
  List<dynamic> listUsuariosByEmpresa = [].obs;
  var textPage = "Usuários".obs;
  var textPageCreate = 'Adicionar um Novo Usuário'.obs;
  var role = "user".obs;
  final User? userFirebasee = FirebaseAuth.instance.currentUser;
  var alturaPadding = 12.0.obs;
  var loading = false.obs;
  final formKey = GlobalKey<FormState>();
  var usuario = {}.obs;
  var status = "no".obs;
  var halCon = 150.0.obs;


  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController empresaController = TextEditingController();
  var roleUsuario= "".obs;
  var nomeUsuario= "".obs;
  var nomeEmpresaOperador = "".obs;
  var idUser = "".obs;
  var foneUser = "".obs;
  final auth = FirebaseAuth.instance;


  userCurrent(BuildContext context) async {
    final userFirebase = auth.currentUser;

    if (userFirebase != null) {

      DatabaseReference usersRef = await FirebaseDatabase.instance
          .ref()
          .child("Users")
          .child(userFirebase.uid);
      await usersRef.once().then((snap) {

        if (snap.snapshot.value != null) {


          if ((snap.snapshot.value as Map)["blockStatus"] == "no") {

            roleUsuario.value = (snap.snapshot.value as Map)["role"];
            nomeUsuario.value=(snap.snapshot.value as Map)["nome"];
            idUser.value = (snap.snapshot.value as Map)["id"];
            foneUser.value = (snap.snapshot.value as Map)["fone"];

            userRole = roleUsuario.value;
            userName = nomeUsuario.value;
            userId = idUser.value;
            userFone = foneUser.value;

            if(userRole=="supervisor"|| userRole=="operador"){

              nomeEmpresaOperador.value = (snap.snapshot.value as Map)["empresa"];
              empresaOperador = nomeEmpresaOperador.value;

            }
            update();
          } else {
            FirebaseAuth.instance.signOut();
            cMethods.displaySnackBar(
                "você está bloqueado. Contate o admin: 2bitsw@gmail.com",
                context);
          }
        } else {
          FirebaseAuth.instance.signOut();
          cMethods.displaySnackBar(
              "Seu email não consta em nosso sistema.", context);
        }
      });
    }

    update();

  }

  getUsuarios(
    BuildContext context,
  ) async {
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

  getUsuario(
      BuildContext context,
      ) async {
    await ref.onValue.listen((event) {
      usuario.clear();
      if (event.snapshot.exists) {
        Map pos = event.snapshot.value as Map;
        usuario.clear();
        usuario.value = pos;
      }
      print("usuario = $usuario");
    });
    update();
  }

  getUsuariosByEmpresa(
    BuildContext context,
    String empresa,
  ) async {

    await ref.orderByChild('empresa').equalTo(empresa).onValue.listen((event) {
      listUsuariosByEmpresa.clear();
      if (event.snapshot.exists) {

        Map pos = event.snapshot.value as Map;

        listUsuariosByEmpresa = pos.values.toList();
      } else {

      }
    });

    update();
  }

  void checkNetworkIsAvailable(BuildContext context, {String? empresa}) {

    signUpFormValidation(context, empresa: empresa);
  }

  signUpFormValidation(BuildContext context, {String? empresa}) {

    if (userNameController.text.trim() == '') {
      cMethods.displaySnackBar('digite o nome do usuário', context);
    } else if (userNameController.text.trim().length < 3) {
      cMethods.displaySnackBar(
          'nome precisa ser maior que 3 caracteres', context);
    } else if (phoneController.text.trim().length < 10) {
      cMethods.displaySnackBar(
          'fone precisa ser maior que 11 caracteres', context);
    } else if (passwordController.text.trim().length < 3) {
      cMethods.displaySnackBar(
          'senha precisa ser maior que 3 caracteres', context);
    } else if (!emailController.text.trim().contains("@")) {
      cMethods.displaySnackBar('digite um email válido', context);
    } else {
      register(context, empresa: empresa);
    }
  }

  register(BuildContext context, {String? empresa}) async {
    var uid = "";
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: 'Registrando sua Conta....'),
    );
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        .then((value) {
      uid = value.user!.uid;

      Map usuario = {};


      if((role.value=="operador"||role.value=="supervisor")&&empresaController.text.length>0){
       empresa=empresaController.text;
      }



      if (empresa != null){
        usuario = {
          "nome": userNameController.text.trim(),
          "email": emailController.text.trim(),
          "fone": phoneController.text.trim(),
          "empresa": empresa,
          "id": uid,
          "blockStatus": "no",
          "role": role.value,

        };
      }else{
        usuario = {
          "nome": userNameController.text.trim(),
          "email": emailController.text.trim(),
          "phone": phoneController.text.trim(),
          "id": uid,
          "blockStatus": "no",
          "role": role.value,
        };

      }



      FirebaseDatabase.instance.ref().child('Users').child(uid).set(usuario);

      if (!context.mounted) return;

      getUsuarios(context);



    }).catchError((e) {
      Navigator.pop(context);
      cMethods.displaySnackBar(e.toString(), context);
    });
    Navigator.pop(context);
    update();
  }

  editUsuario(BuildContext context,id){

    ref.child(id).update({
      "nome": userNameController.text.trim(),
      "fone": phoneController.text.trim(),
    }).then((value) {
      userName=userNameController.text;
      cMethods.displaySnackBar('Usuário editado com sucesso', context);
    });
    Navigator.pop(context);

    update();

  }
  editUsuarioStatus(BuildContext context,String id){
    print("id  $id");
    ref.child(id).update({
      "blockStatus": status.value,
    }).then((value) {
      userName=userNameController.text;

    });

    update();

  }
  editUsuarioRole(BuildContext context,String id){
    ref.child(id).update({

      "role": role.value,
    }).then((value) {
      userName=userNameController.text;

    });

    update();

  }
}
