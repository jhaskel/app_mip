import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/chamadoController.dart';
import 'package:mip_app/controllers/consertandoController.dart';
import 'package:mip_app/controllers/ipController.dart';
import 'package:mip_app/global/util.dart';

class ItemController extends GetxController {
  final ref = FirebaseDatabase.instance.ref('Itens');

  final ChamadoController conCha = Get.put(ChamadoController());
  final ConsertandoController conCon = Get.put(ConsertandoController());


  void createItem(BuildContext context, List listaFinal,String message) async {

    for(var x in listaFinal){
      String id = x['id'].toString();
      String idIp = x['idIp'].toString();
      String chamado = x['chamado'].toString();
      int quant = x['quant'];
      int estoque = x['estoque'];
      String idItem = x['idItem'];

      int est = estoque-quant;



      ref.child(id).set(x).then((value) async {
       await conCha.alterarStatus(chamado,idIp,message);
       await conCon.alteraEstoque(idItem,est);
       // cMethods.displaySnackBar("Luminária adicionada!", context);

   //     conIp.postes.removeWhere((key, value) => key == ipIds);
      }).onError((error, stackTrace) {
    //    cMethods.displaySnackBar("Erro ao Luminária adicionada!", context);

      });

    }




    Navigator.pop(context);
    // buscaPostesDefeito();
   // clear();


  }







}
