import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mip_app/global/util.dart';
import 'package:mip_app/methods/common_methods.dart';

class OrdemController extends GetxController {
  final ref = FirebaseDatabase.instance.ref('Ordens');
  CommonMethods cMethods = CommonMethods();
  List<dynamic> listaOrdens = [].obs;
  var nomePage = 'Ordens'.obs;

  createdOrdem(Map<String, Object> ord, BuildContext context, String ordem) {
    ref.child(ordem).set(ord).then((value) async {
      cMethods.displaySnackBar("Ordem adicionada!", context);

    }).onError((error, stackTrace) {
      cMethods.displaySnackBar("Erro ao adicionar a ordem!", context);
    });
    update();
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
}
