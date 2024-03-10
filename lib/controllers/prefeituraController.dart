
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mip_app/methods/common_methods.dart';

class PrefeituraController extends GetxController{

  final ref = FirebaseDatabase.instance.ref('Prefeitura');
  CommonMethods cMethods = CommonMethods();
  var textPage = "Prefeitura".obs;
  List<dynamic> list = [].obs;
  dynamic prefeitura=[];

  getPrefeitura(BuildContext context,) async {

    list.clear();
    update();

    await ref.orderByChild('isAtivo').equalTo(true).onValue.listen((event) {
      if (event.snapshot.exists) {
        Map pos = event.snapshot.value as Map;
        list.clear();
        list = pos.values.toList();
        prefeitura= list.first;
        print("prefeituraB $prefeitura");
      }
    });
  }


}