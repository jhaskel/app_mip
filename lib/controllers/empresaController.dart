
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mip_app/methods/common_methods.dart';

class EmpresaController extends GetxController{

  final ref = FirebaseDatabase.instance.ref('Empresa');
  CommonMethods cMethods = CommonMethods();
  var textPage = "Empresa".obs;
  List<dynamic> list = [].obs;
  List<dynamic> listEmpresas = [].obs;
  dynamic empresa=[];
  var nomeEmpresa="".obs;
  var cnpjEmpresa="".obs;

  TextEditingController fantasiaController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController cnpjController = TextEditingController();
  TextEditingController contatoController = TextEditingController();
  TextEditingController foneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();


  clear() {
    foneController.clear();
    fantasiaController.clear();
    nomeController.clear();
    cnpjController.clear();
    contatoController.clear();
    emailController.clear();
    cidadeController.clear();


    update();
  }

  getEmpresa(BuildContext context, id) async {
    list.clear();
    await ref.orderByChild('id').equalTo(id).onValue.listen((event) {
      if (event.snapshot.exists) {
        Map pos = event.snapshot.value as Map;
        list.clear();
        list = pos.values.toList();
        empresa= list.first;
        nomeEmpresa(empresa['nome']);
        cnpjEmpresa(empresa['cnpj']);

      }
    });
    update();
  }

  getEmpresaAll(BuildContext context) async {

    await ref.onValue.listen((event) {
      listEmpresas.clear();

      if (event.snapshot.exists) {
        Map pos = event.snapshot.value as Map;
        listEmpresas.clear();
        listEmpresas = pos.values.toList();
      }
    });
    update();
  }

editEmpresa(BuildContext context,id){
    print("iddd $id");
  ref.child(id).update({
    "fantasia": fantasiaController.text.trim(),
    "nome": nomeController.text.trim(),
    "cnpj": cnpjController.text.trim(),
    "nomeContato": contatoController.text.trim(),
    "fone": foneController.text.trim(),
    "email": emailController.text.trim(),
    "cidade": cidadeController.text.trim(),
    "isAtivo":1
  }).then((value) {
    cMethods.displaySnackBar('Empresa editada com sucesso', context);
  });
  getEmpresa(context, id);
  update();

}


}