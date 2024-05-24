import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/chamadoController.dart';
import 'package:mip_app/controllers/controleController.dart';
import 'package:mip_app/controllers/ipController.dart';
import 'package:mip_app/global/util.dart';
import '../methods/common_methods.dart';

class ItemController extends GetxController {
  final ref = FirebaseDatabase.instance.ref('Itens');
  final ref2 = FirebaseDatabase.instance.ref('ItensLicitados');

  final ChamadoController conCha = Get.put(ChamadoController());
  final ControleController conCon = Get.put(ControleController());
  final IpController ipCon = Get.put(IpController());

  List<dynamic> listaItens = [].obs;
  List<dynamic> listaItensChamado = [].obs;
  List<dynamic> listaItensChamadoPdf = [].obs;
  List<dynamic> listaFiltrada = [].obs;
  List<dynamic> listaChamados = [].obs;
  CommonMethods cMethods = CommonMethods();
  var totalOrdem = 0.0.obs;
  var textDetail = "Itens utilizados no conserto".obs;
  var totalChamado = 0.0.obs;
  var loading = false.obs;


  getItensByTipo(String ordem) async {
    await ref.orderByChild('ordem').equalTo(ordem).onValue.listen((event) {
      listaItens.clear();
      listaFiltrada.clear();
      listaChamados.clear();
      totalOrdem(0.0);
      if (event.snapshot.exists) {
        Map maps = event.snapshot.value as Map;
        listaItens = maps.values.toList()
          ..sort(((a, b) => (a["nome"]).compareTo((b["nome"]))));

        Set<String> nomesDuplicados = Set();

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
              .map((e) => [
                    e['cod'],
                    e['unidade'],
                    e['valor'],
                    e['licitacao'],
                    e['empresa']
                  ])
              .toSet();

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


        update();
      } else {

      }
    });
  }

  updateItens( BuildContext context, String ordem) async {
    List lista=[];
    await ref.orderByChild('ordem').equalTo(ordem).onValue.listen((event) async {

      Map maps = event.snapshot.value as Map;
       for(var x in maps.values){
         lista.add(x['id']);
       }
       print("lisx $lista");

       for(var u in lista){
         await ref.child(u).update({ordem:"1"});
       }


    });

    update();
  }

  getItensByChamado(String chamado) async {
    listaItensChamado.clear();

    loading(true);
    update();

    await ref.orderByChild('chamado').equalTo(chamado).onValue.listen((event) {
      if (event.snapshot.exists) {
        Map maps = event.snapshot.value as Map;

        listaItensChamado = maps.values.toList()
          ..sort(((a, b) => (a["nome"]).compareTo((b["nome"]))));

        totalChamado.value =
            listaItensChamado.map((e) => e['total']).reduce((v, e) => v + e);

        loading(false);

        update();
      }
    });
  }

  getItensByChamadoPdf(String ordem) async {

    //chama no detalhe da ordem
    listaItensChamadoPdf.clear();
    loading(true);
    update();

    await ref.orderByChild('ordem').equalTo(ordem).onValue.listen((event) {
      if (event.snapshot.exists) {
        Map maps = event.snapshot.value as Map;

        listaItensChamadoPdf = maps.values.toList()
          ..sort(((a, b) => (a["nome"]).compareTo((b["nome"]))));

        var fg = listaItensChamadoPdf.map((e) => e['chamado']).toSet().toList();

        List<Map<String, Map<String, dynamic>>> lista = [];

        Map<String, Map<String, dynamic>> ls = {};
        for (var x in fg) {
          for (var y in listaItensChamadoPdf) {
            if (y['chamado'] == x) {
              var pro = {
                "chamado": x,
                "nome": y['nome'],
                "unidade": y['unidade'],
                "quant": y['quant'],
                "ip": y['idIp'],
              };

              ls.putIfAbsent(pro['chamado'], () => pro);
              lista.add(ls);
            }
          }
        }

        loading(false);
        update();
      } else {

      }
    });
  }

  adicionarItemLicitado(Map<String, dynamic> iten) async {
   await  ref.child(iten['id']).set(iten);
   ref2.child(iten['idItem']).update({
     "ordenacao": iten['ordenacao']+1,

   });
    update();
  }





  alteraQuant(dynamic item, bool acrescenta) {
    String id = item['id'];
    double valor = item['valor'];
    double total = item['total'];
    int quan = item['quant'];
    if (acrescenta) {
   quan=quan+1;
   total =  quan*valor;
      ref.child(id).update({
        "quant": quan,
        "total":total
      });


    } else {
      if (quan > 1) {
        quan=quan-1;
        total =  quan*valor;
        ref.child(id).update({
          "quant": quan,
          "total":total
        });

      }
    }

    update();
  }

  removeItemFirebase(item){
    ref.child(item['id']).remove();
    update();
  }


  alteraOrdem(id, ordem) {
    ref.child(id).update({
      "ordem": ordem,
    });
    update();
  }
}
