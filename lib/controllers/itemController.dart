import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/chamadoController.dart';
import 'package:mip_app/controllers/controleController.dart';

class ItemController extends GetxController {
  final ref = FirebaseDatabase.instance.ref('Itens');
  final refOr = FirebaseDatabase.instance.ref('Itens');

  final ChamadoController conCha = Get.put(ChamadoController());
  final ControleController conCon = Get.put(ControleController());

  List<dynamic> listaItens = [].obs;
  List<dynamic> listaFiltrada = [].obs;
  var totalOrdem = 0.0.obs;

  getItens(String ordem) async {
    await ref.orderByChild('ordem').equalTo(ordem).onValue.listen((event) {
      listaItens.clear();
      listaFiltrada.clear();
      if (event.snapshot.exists) {
        Map maps = event.snapshot.value as Map;

        listaItens = maps.values.toList()
          ..sort(((a, b) => (a["nome"]).compareTo((b["nome"]))));

        Set<String> nomesDuplicados = Set();
        var df;

        for (var x in listaItens) {
          if (!nomesDuplicados.contains(x['nome'])) {
            nomesDuplicados.add(x['nome']);
          }
        }

        for (var f in nomesDuplicados) {
          var b =
              listaItens.where((e) => e['nome'] == f).map((e) => e['quant']);
          int gh = b.reduce((v, e) => v + e);
          var c = listaItens
              .where((e) => e['nome'] == f)
              .map((e) => [e['cod'], e['unidade'], e['valor']])
              .toSet();
          print("$f -  ${gh} -  ${c.first[0]} - ${c.first[1]} - ${c.first[2]}");

          var total = gh * c.first[2];

          var it = {
            "cod": c.first[0],
            "unidade": c.first[1],
            "nome": f,
            "quant": gh,
            "valor": c.first[2],
            "total": total,
          };

          listaFiltrada.add(it);
          totalOrdem.value =
              listaFiltrada.map((e) => e['total']).reduce((a, b) => a + b);
        }
        print("it $totalOrdem");

        update();
      }
    });
  }

  createItem(BuildContext context, List listaFinal, String message) async {
    for (var x in listaFinal) {
      String id = x['id'].toString();
      String idIp = x['idIp'].toString();
      String chamado = x['chamado'].toString();
      int quant = x['quant'];
      int estoque = x['estoque'];
      String idItem = x['idItem'];

      int est = estoque - quant;

      ref.child(id).set(x).then((value) async {
        await conCha.alterarStatus(chamado, idIp, message);
        await conCon.alteraEstoque(idItem, est);
        // cMethods.displaySnackBar("Luminária adicionada!", context);

        //     conIp.postes.removeWhere((key, value) => key == ipIds);
      }).onError((error, stackTrace) {
        //    cMethods.displaySnackBar("Erro ao Luminária adicionada!", context);
      });
    }

    conCha.buscaPostesDefeito();
    Navigator.pop(context);
    // clear();
  }

  alteraOrdem(id, ordem) {
    ref.child(id).update({
      "ordem": ordem,
    });
    update();
  }
}
