import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mip_app/global/util.dart';
import 'package:mip_app/methods/common_methods.dart';

class CosipController extends GetxController {
  final ref = FirebaseDatabase.instance.ref('Cosip');
  CommonMethods cMethods = CommonMethods();
  List<dynamic> listaCosip = [].obs;
  List<dynamic> listaReceitasCosipByAno = [].obs;
  List<dynamic> listaDespesasCosipByAno = [].obs;
  List<dynamic> listaDotacoes = [].obs;
  var codDotacao = "".obs;

  var totalDotacao = 0.0.obs;
  var totalReceitasCosipByAno = 0.0.obs;
  var totalDespesasCosipByAno = 0.0.obs;
  var receitaCaixa = 0.0.obs;
  var receitaOrcamentaria = 0.0.obs;
  var nomePage = 'Cosip'.obs;

  //cadastro
  TextEditingController codController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController valorController = TextEditingController();
  TextEditingController mesController = TextEditingController();
  TextEditingController tipoController = TextEditingController();
  TextEditingController dotacaoController = TextEditingController();


  clear() {
    codController.clear();
    nomeController.clear();
    valorController.clear();
    mesController.clear();
    tipoController.clear();
    dotacaoController.clear();

    update();
  }

  createdCosip(Map<String, Object> ord, BuildContext context, String cosip) {
    ref.child(cosip).set(ord).then((value) async {
      cMethods.displaySnackBar("Cosip adicionada!", context);

    }).onError((error, stackTrace) {
      cMethods.displaySnackBar("Erro ao adicionar a cosip!", context);
    });
    update();
  }



  getDotacaoByAno(String ano) async {
    await ref.child('dotacao').child(ano).onValue.listen((event) {
      listaDotacoes.clear();

      if (event.snapshot.exists) {
        Map maps = event.snapshot.value as Map;

        listaDotacoes = maps.values.toList()
          ..sort(((a, b) => (b["tipo"]).compareTo((a["tipo"]))));

        var totalizadando= listaDotacoes.map((e) => e['valor']).reduce((v, e) => v+e);
        totalDotacao (totalizadando);

        print(listaDotacoes.length);


        update();
      }
    });
  }

  getDotacaoByAnoByTipo(String ano,String tipo) async {
    print("0009 $ano $tipo");
    await ref.child('dotacao').child(ano).orderByChild('tipo').equalTo(tipo).onValue.listen((event) {
      listaDotacoes.clear();

      if (event.snapshot.exists) {
        print("0008");
        Map maps = event.snapshot.value as Map;

        listaDotacoes = maps.values.toList();

        print("listaDotacoes.length ${listaDotacoes.length}");
        print("codDotacao ${listaDotacoes}");
        codDotacao(listaDotacoes.last['cod']);
        print("codDotacao $codDotacao");

        update();
      }
      print("0007");
    });
  }

  getReceitasCosipByAno(String ano) async {

    await ref.child('receitas').child(ano).onValue.listen((event) {
      listaReceitasCosipByAno.clear();

      if (event.snapshot.exists) {
        Map maps = event.snapshot.value as Map;

        listaReceitasCosipByAno = maps.values.toList()
          ..sort(((a, b) => (b["mes"]).compareTo((a["mes"]))));

        var totalizando = listaReceitasCosipByAno.map((e) => e['valor']).reduce((v, e) => v+e);
        totalReceitasCosipByAno(totalizando);


        update();
      }
    });
  }

  getDespesasCosipByAno(String ano) async {


    await ref.child('despesas').child(ano).onValue.listen((event) {
      listaDespesasCosipByAno.clear();


      if (event.snapshot.exists) {

        Map maps = event.snapshot.value as Map;

        listaDespesasCosipByAno = maps.values.toList()
          ..sort(((a, b) => (b["mes"]).compareTo((a["mes"]))));



        var totalizando = listaDespesasCosipByAno.map((e) => e['valor']).reduce((v, e) => v+e);
        totalDespesasCosipByAno(totalizando);

        receitaOrcamentaria(totalDotacao.value-totalDespesasCosipByAno.value);
        receitaCaixa(totalReceitasCosipByAno.value-totalDespesasCosipByAno.value);



        update();
      }
    });
  }

  createdDotacao(BuildContext context) {
    String ano = DateTime.now().year.toString();
    var nome="itens";
    int tipo =int.parse(tipoController.text);
    if(tipo==2){
      nome="serviços";

    }
    if(tipo==3){
      nome="energia";

    }
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    var dotacao={
      "cod":codController.text,
      "id":id,
      "nome":nome,
      "valor":double.parse(valorController.text),
      "tipo":tipoController.text,
    };
    ref.child('dotacao').child(ano).child(id).set(dotacao).then((value) async {
      cMethods.displaySnackBar("Dotação adicionada!", context);

    }).onError((error, stackTrace) {
      cMethods.displaySnackBar("Erro ao adicionar a dotação!", context);
    });
    clear();
    update();
  }

  createdReceita(BuildContext context) {
    String ano = DateTime.now().year.toString();
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    var receita={
      "mes":mesController.text,
      "nome":nomeController.text,
      "id":id,
      "valor":double.parse(valorController.text),

    };
    ref.child('receitas').child(ano).child(id).set(receita).then((value) async {
      cMethods.displaySnackBar("Receita adicionada!", context);

    }).onError((error, stackTrace) {
      cMethods.displaySnackBar("Erro ao adicionar a receita!", context);
    });
    clear();
    update();
  }
  createdDespesaEnegia(BuildContext context) {
    String ano = DateTime.now().year.toString();
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    var despesa={
      "mes":mesController.text,
      "nome":nomeController.text,
      "dotacao":dotacaoController.text,
      "id":id,
      "valor":double.parse(valorController.text),

    };
    ref.child('despesas').child(ano).child(id).set(despesa).then((value) async {
      cMethods.displaySnackBar("Despesa adicionada!", context);

    }).onError((error, stackTrace) {
      cMethods.displaySnackBar("Erro ao adicionar a despesa!", context);
    });
    clear();
    update();
  }

  createdDespesa(BuildContext context, Map<String, dynamic> despesa) {
    String ano = DateTime.now().year.toString();

    ref.child('despesas').child(ano).child(despesa['id']).set(despesa).then((value) async {
      cMethods.displaySnackBar("Despesa adicionada!", context);

    }).onError((error, stackTrace) {
      cMethods.displaySnackBar("Erro ao adicionar a despesa!", context);
    });
    clear();
    update();
  }


}
