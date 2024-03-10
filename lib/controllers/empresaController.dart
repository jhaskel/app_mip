
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mip_app/methods/common_methods.dart';

class EmpresaController extends GetxController{

  final ref = FirebaseDatabase.instance.ref('Empresa');
  CommonMethods cMethods = CommonMethods();
  var textPage = "Empresa".obs;
  List<dynamic> list = [].obs;
  dynamic empresa=[];

  getEmpresa(BuildContext context, id) async {

    list.clear();
    update();

    await ref.orderByChild('id').equalTo(id).onValue.listen((event) {
      if (event.snapshot.exists) {
        Map pos = event.snapshot.value as Map;
        list.clear();
        list = pos.values.toList();
        empresa= list.first;
        print("empresaB $empresa");
      }
    });
  }


}