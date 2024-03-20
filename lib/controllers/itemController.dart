import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/chamadoController.dart';
import 'package:mip_app/controllers/controleController.dart';
import 'package:mip_app/global/global_var.dart';
import 'package:mip_app/global/util.dart';

class ItemController extends GetxController {
  final ref = FirebaseDatabase.instance.ref('Itens');


  final ChamadoController conCha = Get.put(ChamadoController());
  final ControleController conCon = Get.put(ControleController());

  List<dynamic> listaItens = [].obs;
  List<dynamic> listaItensChamado = [].obs;
  List<dynamic> listaItensChamadoPdf = [].obs;
  List<dynamic> listaFiltrada = [].obs;
  List<dynamic> listaChamados = [].obs;

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
        print("existe");
        Map maps = event.snapshot.value as Map;

        listaItens = maps.values.toList()
          ..sort(((a, b) => (a["nome"]).compareTo((b["nome"]))));

        Set<String> nomesDuplicados = Set();


      //  listaChamados =listaItens.map((e) => e['chamado']).toSet().toList();//seleciona os chamados para autulizar numero da ordem;

//print("lista chamados $listaChamados");

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
          print("lst $listaItens}");

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
      }else{
        print("não existe");
      }
    });
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
    print("veio");
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

        List<Map<String,Map<String,dynamic>>> lista=[];


        Map<String,Map<String,dynamic>> ls = {};
for(var x in fg){
  for(var y in listaItensChamadoPdf){
    if(y['chamado']==x){
      var pro = {
        "chamado":x,
        "nome":y['nome'],
        "unidade":y['unidade'],
        "quant":y['quant'],
        "ip":y['idIp'],
      };
      print("Pro $pro");
      ls.putIfAbsent(pro['chamado'], () => pro);

    //  print("lssssssssssssss $ls");

      lista.add(ls);
   //   print("listaInicial $ls");
     // lista.add(pro);

    }
  }

}
print("listaFinal $lista");


        loading(false);
        update();
      }else{
        print("passou");
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

      int est = estoque - quant;

      ref.child(id).set(x).then((value) async {
      if(userRole==Util.roles[1]){
        await conCha.alterarStatus(context, chamado, idIp, message, 0.0);
      }

        await conCha.alterarStatus(context, chamado, idIp, message, 0.0);
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
    update();
    // clear();
  }

  alteraOrdem(id, ordem) {
    ref.child(id).update({
      "ordem": ordem,
    });
    update();
  }
}
