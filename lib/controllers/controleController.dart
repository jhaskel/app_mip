import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControleController extends GetxController {
  var index = 0.obs;
  List<dynamic> lista = [].obs;
  List<dynamic> listaItens = [].obs;
  List<dynamic> listaServicos = [].obs;
  List<dynamic> listaFinal = [].obs;
  final ref = FirebaseDatabase.instance.ref('ItensLicitados');
  final refIten = FirebaseDatabase.instance.ref('Itens');
  var loading = false.obs;
  var quant = 1.obs;
  var total = 0.0.obs;

  getItens() async {
    listaItens.clear();
    listaServicos.clear();

    await ref.get().then((value) {
      if (value.exists) {
        Map maps = value.value as Map;

        var lista = maps.values.toList();

        lista = maps.values.toList()
          ..sort(((a, b) => (b["ordenacao"]).compareTo((a["ordenacao"]))));

        for (var x in lista) {
          int tipo = x['tipo'];

          if (tipo == 1) {
            listaItens.add(x);
          } else {
            listaServicos.add(x);
          }
        }

        update();
      }
    });
  }

  getItensUtilizados(String chamado) async {
    listaFinal.clear();
    await refIten.orderByChild('chamado').equalTo(chamado).get().then((value) {
      if (value.exists) {
        Map maps = value.value as Map;

        var lista = maps.values.toList();

        lista = maps.values.toList()
          ..sort(((a, b) => (b["nome"]).compareTo((a["nome"]))));

        for (var x in lista) {
          listaFinal.add(x);
        }

        update();
      }
    });
  }

  adicionarItemLicitado(listaIten) {
    listaFinal.add(listaIten);
    total(listaIten['total']);

    // var tes = listaFinal.map((e) => e['total']);
    //   total(tes.reduce((a, b) => a+b));
    //   print('total $total');
    update();
  }

  alteraQuant(dynamic lista, int index, bool tipo) {
    double valor = lista['valor'];
    int esto = lista['estoque'];
    int quan = lista['quant'];

    if (tipo) {
      if (quan < esto) {
        listaFinal[index]['quant']++;

        print("${listaFinal[index]['quant']}");
        update();
      } else {
        Get.defaultDialog(title: "OOPs", content: Text("Estoque insufuciente"));
      }
    } else {
      if (listaFinal[index]['quant'] > 1) {
        listaFinal[index]['quant']--;
        update();
      }
    }
    double tot = valor * lista['quant'];

    listaFinal[index]['total'] = tot;
    update();
  }

  removerItemLicitado(dynamic item) {
    listaFinal.removeWhere((e) => e['id'] == item['id']);
    update();
  }

  resetarListaItemLicitado() {
    listaFinal.clear();
    update();
  }

  alteraEstoque(String id, estoque, int ordenar) {
    ref.child(id).update({
      "estoque": estoque,
      "ordenacao": ordenar,
      "modifiedAt": DateTime.now().toString(),
    });
  }
}
