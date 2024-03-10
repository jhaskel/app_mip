import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/chamadoController.dart';
import 'package:mip_app/controllers/controleController.dart';
import 'package:mip_app/global/util.dart';

class ItemController extends GetxController {
  final ref = FirebaseDatabase.instance.ref('Itens');
  final refOr = FirebaseDatabase.instance.ref('Itens');

  final ChamadoController conCha = Get.put(ChamadoController());
  final ControleController conCon = Get.put(ControleController());

  List<dynamic> listaItens = [].obs;
  List<dynamic> listaItensChamado = [].obs;
  List<dynamic> listaFiltrada = [].obs;
  var totalOrdem = 0.0.obs;
  var textDetail = "Itens utilizados no conserto".obs;
  var totalChamado = 0.0.obs;

  getItensByTipo(String ordem) async {
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
              .map((e) => [e['cod'], e['unidade'], e['valor'],e['licitacao'],e['empresa']])
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
            "licitacao": c.first[3],
            "empresa": c.first[4],
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

  getItensByChamado(String chamado) async {
    print("id $chamado");
    await ref.orderByChild('chamado').equalTo(chamado).onValue.listen((event) {
      listaItensChamado.clear();

      if (event.snapshot.exists) {
        Map maps = event.snapshot.value as Map;

        listaItensChamado = maps.values.toList()
          ..sort(((a, b) => (a["nome"]).compareTo((b["nome"]))));

        totalChamado.value =
            listaItensChamado.map((e) => e['total']).reduce((v, e) => v + e);
        print("totalchamdo $totalChamado");

        update();
      }
    });
  }

  createItem(BuildContext context, List listaFinal, String message) async {
    int ordenar = 0;
    for (var x in listaFinal) {
      String id = x['id'].toString();
      String idIp = x['idIp'].toString();
      String chamado = x['chamado'].toString();
      int quant = x['quant'];
      int estoque = x['estoque'];
      String idItem = x['idItem'];
      ordenar = x['ordenacao'] + 1;

      print("ordena $ordenar");

      int est = estoque - quant;

      ref.child(id).set(x).then((value) async {
        await conCha.alterarStatus(chamado, idIp, message, 0.0);
        await conCon.alteraEstoque(idItem, est, ordenar);

        // cMethods.displaySnackBar("Luminária adicionada!", context);

        //     conIp.postes.removeWhere((key, value) => key == ipIds);
      }).onError((error, stackTrace) {
        //    cMethods.displaySnackBar("Erro ao Luminária adicionada!", context);
      });
    }

    conCha.buscaPostesDefeito();

    if (message != StatusApp.lancado.message) {
      Navigator.pop(context);
    }

    // clear();
  }

  alteraOrdem(id, ordem) {
    ref.child(id).update({
      "ordem": ordem,
    });
    update();
  }
}
