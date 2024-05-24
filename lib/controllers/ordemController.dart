import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mip_app/global/util.dart';
import 'package:mip_app/methods/common_methods.dart';

class OrdemController extends GetxController {
  final ref = FirebaseDatabase.instance.ref('Ordens');
  CommonMethods cMethods = CommonMethods();
  List<dynamic> listaOrdens = [].obs;
  List<dynamic> listaOrdensAbertas = [].obs;
  List<dynamic> listaOrdensByAno = [].obs;
  var totalByAno = 0.0.obs;
  var nomePage = 'Ordens'.obs;
  var tem = false.obs;
  var idOrdem = "".obs;
  var ordemConfirmada = false.obs;



  createdOrdem(Map<String, Object> ord, BuildContext context, String ordem) {
    ref.child(ordem).set(ord).then((value) async {
      cMethods.displaySnackBar("Ordem adicionada!", context);

    }).onError((error, stackTrace) {
      cMethods.displaySnackBar("Erro ao adicionar a ordem!", context);
    });
    update();
  }

  updateOrdem(Map<String, Object> ord, BuildContext context, String ordem) {
    ref.child(ordem).update(ord).then((value) async {
      cMethods.displaySnackBar("Ordem adicionada!", context);

    }).onError((error, stackTrace) {
      cMethods.displaySnackBar("Erro ao adicionar a ordem!", context);
    });
    update();
  }
  getOrdemByFinalizada(String id) async {
    print("HAS ${tem.value}");
    print("HAS2 ${id}");


    await ref.orderByChild('isAberta').equalTo("1.1").onValue.listen((event) {
      listaOrdensAbertas.clear();

      if (event.snapshot.exists) {
        Map maps = event.snapshot.value as Map;

        for(var x in maps.keys){
          idOrdem.value = x;
print("xxxxxxx ${idOrdem.value}");
        }
        tem(true);
        update();
        print("HAS1 ${maps}");
      }else{
        print("não foi encontrado ");
      }
    });





  }

  getOrdem() async {
    await ref.onValue.listen((event) {
      listaOrdens.clear();

      if (event.snapshot.exists) {
        Map maps = event.snapshot.value as Map;

        listaOrdens = maps.values.toList()
          ..sort(((a, b) => (b["createdAt"]).compareTo((a["createdAt"]))));

        print(listaOrdens);
        for (var x in listaOrdens) {
          for (var z in x['itensOrdem']) {}
        }

        update();
      }
    });
  }


  getOrdensByAno(String ano) async {
    //ainda não utilizado
    await ref.onValue.listen((event) {
      listaOrdensByAno.clear();

      if (event.snapshot.exists) {
        Map maps = event.snapshot.value as Map;

        listaOrdensByAno = maps.values.toList()
          ..sort(((a, b) => (b["mes"]).compareTo((a["mes"]))));

        var totalizando = listaOrdensByAno.map((e) => e['valor']).reduce((v, e) => v+e);
        totalByAno(totalizando);


        update();
      }
    });
  }

  alteraStatusUrl(String id, String url, String tipoFile) {
    if(tipoFile=="sf"){
      ref.child(id).update({
        "urlSf": url,
        "status":StatusApp.aguardandoNota.message
      });
    }else{
      ref.child(id).update({
        "urlNf": url,
        "status":StatusApp.notaGerada.message
      });
    }


    update();
  }

  void alterarStatus(BuildContext context, String message, item) {

    ref.child(item['id']).update({
      "status": message,
      "isConfirmada":true

    });
  }
}
