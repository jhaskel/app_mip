import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/ipController.dart';
import 'package:mip_app/global/util.dart';
import 'package:mip_app/methods/common_methods.dart';

class ChamadoController extends GetxController {
  final ref = FirebaseDatabase.instance.ref('Chamado');

  var idIp = "".obs;
  var codIp = "".obs;
  var loading = false.obs;
  var defeito = "".obs;
  CommonMethods cMethods = CommonMethods();
  final IpController conIp = Get.put(IpController());
  var textPage = "Chamados".obs;
  var alturaWidget = 120.0.obs;
  List<dynamic> listaChamados = [].obs;
  var indexDefeito = 100.obs;

  void getChamados(BuildContext context) async {
    await ref.orderByChild('status').equalTo('defeito').get().then((value) {
      Map pos = value.value as Map;
      listaChamados.clear();
      listaChamados = pos.values.toList();
    });

    update();
  }

  void createChamado(BuildContext context) async {
    String id = DateTime.now().millisecondsSinceEpoch.toString();

    String ipId = idIp.value;

    var chamado = {
      'id': id,
      'idIp': idIp.value, //id do Ip
      'createdAt': DateTime.now().toIso8601String(),
      'modifiedAt': DateTime.now().toIso8601String(),
      'status': StatusApp.defeito.message,
      'defeito': defeito.value,
    };
    ref.child(id).set(chamado).then((value) async {
      await conIp.alteraStatusIp(context, ipId);
      cMethods.displaySnackBar("Luminária adicionada!", context);
      loading(false);
    }).onError((error, stackTrace) {
      cMethods.displaySnackBar("Erro ao Luminária adicionada!", context);
      loading(false);
    });
    clear();

    // Navigator.pop(context);

    update();
  }

  removeChamado(String id, BuildContext context) {
    ref.child(id).remove().then((value) {
      cMethods.displaySnackBar("${textPage.value} excluido!", context);
    }).onError((error, stackTrace) {
      cMethods.displaySnackBar(
          "Não foi possivel Excluir ${textPage.value}", context);
    });
  }

  List<dynamic> listaItens = [].obs;
  List<dynamic> listaItens2 = [].obs;
  var postes = Map<String, dynamic>().obs;

  clear() {
    idIp("");
    codIp("");
    loading(false);
    defeito("");
    indexDefeito(100);
    update();
  }
}
