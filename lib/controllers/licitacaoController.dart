
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mip_app/methods/common_methods.dart';

class LicitacaoController extends GetxController{

  final ref = FirebaseDatabase.instance.ref('Licitacao');
  CommonMethods cMethods = CommonMethods();
  var textPage = "Licitacao".obs;
  List<dynamic> list = [].obs;
  dynamic licitacao=[];

  getLicitacao(BuildContext context, ip) async {

    list.clear();
    update();

    await ref.orderByChild('id').equalTo(ip).onValue.listen((event) {
      if (event.snapshot.exists) {
        Map pos = event.snapshot.value as Map;
        list.clear();
        list = pos.values.toList();
        licitacao= list.first;
        print("licitacaoB $licitacao");
      }
    });
  }


}