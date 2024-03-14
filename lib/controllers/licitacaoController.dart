
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mip_app/methods/common_methods.dart';

class LicitacaoController extends GetxController{

  final ref = FirebaseDatabase.instance.ref('Licitacao');
  final refLicItens = FirebaseDatabase.instance.ref('ItensLicitados');
  CommonMethods cMethods = CommonMethods();
  var textPage = "Licitacao".obs;
  var textPageDetail = "Detalhe da Licitação".obs;
  var alturaContainer = 50.0.obs;

  List<dynamic> list = [].obs;
  List<dynamic> listLicitacoes = [].obs;
  dynamic licitacao=[];


  getLicitacao(BuildContext context) async {
    list.clear();
    update();

    await ref.onValue.listen((event) {
      if (event.snapshot.exists) {
        Map pos = event.snapshot.value as Map;
        listLicitacoes.clear();
        listLicitacoes = pos.values.toList();
        licitacao= listLicitacoes.first;
        print("licitacaoB $licitacao");
      }
    });
  }

  getLicitacaoById(BuildContext context, id) async {
    list.clear();
    update();

    await ref.orderByChild('id').equalTo(id).onValue.listen((event) {
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