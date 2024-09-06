import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mip_app/controllers/ipController.dart';
import 'package:mip_app/controllers/itemController.dart';
import 'package:mip_app/global/global_var.dart';
import 'package:mip_app/global/util.dart';
import 'package:mip_app/methods/common_methods.dart';
import 'package:mip_app/widgets/ChamadoBottonSheet.dart';

class ChamadoController extends GetxController {
  final ref = FirebaseDatabase.instance.ref('Chamado');
  final refIp = FirebaseDatabase.instance.ref('Ip');
  var alturaContainer = 50.0.obs;
  var idIp = "".obs;
  var codIp = "".obs;
  var loading = false.obs;
  var defeito = "".obs;
  CommonMethods cMethods = CommonMethods();
  var totalChamado = 0.0.obs;
  final IpController conIp = Get.put(IpController());
  var textPage = "Chamados".obs;
  var alturaWidget = 120.0.obs;
  List<dynamic> listaChamados = [].obs;
  var indexDefeito = 100.obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var lati = 0.0.obs;
  var longi = 0.0.obs;
  var bairro = "".obs;
  var logradouro = "".obs;
  LatLng? markerPosition;
  var dragged = false.obs;
  var quantChamados = 0.obs;
  var chamadosAndamento = 0.obs;
  var chamadosFinalizados = 0.obs;
  var gastosTotalChamados = 0.0.obs;

  List<String> icones = [
    'assets/poste-normal.png',
    'assets/poste-defeito.png',
    'assets/poste-agendado.png',
    'assets/poste-relatado.png',
    'assets/poste-realizado.png'
  ];
  final markers = Set<Marker>().obs;
  List<dynamic> list = [].obs;
  List<dynamic> listChamadosByIP = [].obs;

  Map maps = {};

  var postes = Map<String, dynamic>().obs;

  LatLng _position = LatLng(-27.35661, -49.88283);
  var position2 = LatLng(-27.35661, -49.88283).obs;
  late GoogleMapController _mapsController;

  static ItemController get itecon => Get.find<ItemController>();
  get mapsController => _mapsController;
  get position => _position;

  onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    getPosicao();
    var style = await rootBundle.loadString('assets/map/dark.json');
    _mapsController.setMapStyle(style);
  }

  Future<Position> _posicaoAtual() async {
    LocationPermission permissao;
    bool ativado = await Geolocator.isLocationServiceEnabled();

    if (!ativado) {
      return Future.error('Por favor, habilite a localização no smartphone.');
    }

    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();

      if (permissao == LocationPermission.denied) {
        return Future.error('Você precisa autorizar o acesso à localização.');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      return Future.error('Autorize o acesso à localização nas configurações.');
    }

    return await Geolocator.getCurrentPosition();
  }

  getPosicao() async {
    try {
      final posicao = await _posicaoAtual();
      latitude.value = posicao.latitude;
      longitude.value = posicao.longitude;

      _mapsController.animateCamera(
          CameraUpdate.newLatLng(LatLng(latitude.value, longitude.value)));
    } catch (e) {
      Get.snackbar(
        'Erro',
        e.toString(),
        backgroundColor: Colors.grey[900],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  changeDefeito(valor, index) {
    defeito(valor);
    indexDefeito(index);

    update();
  }

  changeLat(LatLng target) {
    position2(target);
    update();
  }

  void getChamadosByIp(BuildContext context, ip) async {
    print("ip,....$ip");
    listChamadosByIP.clear();
    update();

    await ref.orderByChild('idIp').equalTo(ip).onValue.listen((event) {
      if (event.snapshot.exists) {
        Map pos = event.snapshot.value as Map;
        listChamadosByIP.clear();
        listChamadosByIP = pos.values.toList();
        print(listChamadosByIP.length);
      }
    });
  }

  void createChamado(BuildContext context) async {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    String ipIds = idIp.value;
   int  ano = DateTime.now().year;
    var chamado = {
      'id': "id$id",
      'idIp': ipIds,
      'createdAt': DateTime.now().toString(),
      'modifiedAt': DateTime.now().toString(),
      'latitude': lati.value,
      'longitude': longi.value,
      'status': StatusApp.defeito.message,
      'defeito': defeito.value,
      'empresa': '',
      'total': 0.0,
      'isChamado': true,
      'bairro':bairro.value,
      'logradouro':logradouro.value,
      'ano':ano,
    };

    ref.child("id$id").set(chamado).then((value) async {
      await conIp.alteraStatusIp(ipIds, StatusApp.defeito.message);
      cMethods.displaySnackBar("Luminária adicionada!", context);

      conIp.postes.removeWhere((key, value) => key == ipIds);
    }).onError((error, stackTrace) {
      cMethods.displaySnackBar("Erro ao Luminária adicionada!", context);
    });

  //  Navigator.pop(context);
    // buscaPostesDefeito();
    clear();
  }

  removeChamado(String id, BuildContext context) {
    ref.child(id).remove().then((value) {
      cMethods.displaySnackBar("${textPage.value} excluido!", context);
    }).onError((error, stackTrace) {
      cMethods.displaySnackBar(
          "Não foi possivel Excluir ${textPage.value}", context);
    });
  }

  buscaPostesDefeito() async {
    loading(true);
    markers.clear();
    await ref.orderByChild('isChamado').equalTo(true).onValue.listen((event) {
      if (event.snapshot.exists) {
        Map maps = event.snapshot.value as Map;
        list.clear();
        list = maps.values.toList();
        for (var x in list) {
          print("x ${x['idIp']}");
          addMarcadorDefeito(x);
          refIp.child(x['idIp']).update({
            "status": 'defeito',
          });
        }
      }
      loading(false);
      update();
    });
  }

  addMarcadorDefeito(x) async {
    String iconPoste = icones[0];

    if (x['status'] == StatusApp.normal.message) {
      iconPoste = icones[0];
    } else if (x['status'] == StatusApp.defeito.message) {
      iconPoste = icones[1];
    } else if (x['status'] == StatusApp.agendado.message) {
      iconPoste = icones[2];
    } else if (x['status'] == StatusApp.concertando.message) {
      iconPoste = icones[3];

    } else if (x['status'] == StatusApp.realizado.message) {
      iconPoste = icones[4];

    } else {
      iconPoste = icones[0];
    }

    final MarkerId markerId = MarkerId(x['idIp']);
    markers.add(
      Marker(
        markerId: markerId,
        position: LatLng(x['latitude'], x['longitude']),
        infoWindow: InfoWindow(title: x['idIp']),

        icon: await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(20, 20)), iconPoste),
        //   icon: BitmapDescriptor.defaultMarkerWithHue(250),
        draggable: dragged.value,
        //  onDragEnd: (LatLng position) => _onMarkerDragEnd(markerId, position),
        //   onDrag: (LatLng position) => _onMarkerDrag(markerId, position),
        onTap: () => {bottonSheet(x)},
      ),
    );

    update();
  }

  Future<dynamic> bottonSheet(chamado) async {
    return Get.bottomSheet(
      ChamadoBottonSheet(
        chamado: chamado,
      ),
      barrierColor: Colors.transparent,
    );
  }

  getIpUnico(String id) async {
    await refIp.child(id).get().then((value) {
      Map ips = value.value as Map;
      lati.value = ips['latitude'];
      longi.value = ips['longitude'];
      bairro.value = ips['Bairro'];
      logradouro.value = ips['logradouro'];

    });

    update();
  }


  void getChamados(BuildContext context) async {
    int ano = DateTime.now().year;
    quantChamados(0);
    chamadosAndamento(0);
    chamadosFinalizados(0);
    gastosTotalChamados(0.0);
   ////////////////////


    await ref.orderByChild('ano').equalTo(ano).get().then((value) async {
      Map pos = value.value as Map;

      listaChamados.clear();
      listaChamados = pos.values.toList()
        ..sort(((a, b) => (b["createdAt"]).compareTo((a["createdAt"]))));


   ////////////////

      quantChamados(listaChamados.length);
      double soma =
          listaChamados.map((e) => e['total']).reduce((v, e) => v + e);

      gastosTotalChamados(soma);

     quantChamados(listaChamados.length);
      for (var x in listaChamados) {

        if (x['isChamado'] == true) {
          chamadosAndamento++;
        }
      }

      chamadosFinalizados(quantChamados.value - chamadosAndamento.value);
    });

    update();
  }

  void getChamadosRealizado(BuildContext context) async {
    await ref.orderByChild('status').equalTo('realizado').get().then((value) {
      Map pos = value.value as Map;
      listaChamados.clear();
      listaChamados = pos.values.toList();
      print(listaChamados.length);
    });
    update();
  }

  var quantLancados = 0.obs;

  getChamadosLancado(BuildContext context) async {

    await ref.orderByChild('status').equalTo('lancado').onValue.listen((event) {

      if (event.snapshot.exists) {
        Map maps = event.snapshot.value as Map;
       // print('maps $maps');

        var list = maps.values.toList();
        list = maps.values.toList();
        quantLancados(list.length);

        print("quantLancados ${quantLancados}");



      }


      update();
    });
  }

  clear() {
    idIp("");
    codIp("");
    defeito("");
    indexDefeito(100);
    defeito("");
    update();
  }


  finalizarConcerto(BuildContext context, String message, dynamic chamado) async {

    String idIp = chamado['idIp'];
    alterarStatus(context, chamado['id'], idIp, message, 0.0);

    buscaPostesDefeito();
    if (message != StatusApp.lancado.message) {
      Navigator.pop(context);
    }
    update();
    // clear();
  }


  alterarStatus(BuildContext context,String id, String idIp, String message, double total) async {
    if(userRole==Util.roles[1]){
      ref.child(id).update({
        "status": message,
        "empresa":userRole==Util.roles[1]?empresaOperador:"",
        "total": totalChamado.value,
        "isChamado": message == StatusApp.autorizado.message ? false : true,
        "modifiedAt": DateTime.now().toString(),
        "realizadoBy":userRole==Util.roles[1]&& message == StatusApp.realizado.message?userName:"",
      }).then((value) {
        cMethods.displaySnackBar(
            "Chamado concertado com sucesso! ${textPage.value}", context);

        if (message == StatusApp.autorizado.message) {
          conIp.alteraStatusIp(idIp, StatusApp.normal.message);

        } else {
          conIp.alteraStatusIp(idIp, message);
        }
      });
      await buscaPostesDefeito();
      conIp.buscaPostes();
      update();

    }
    if(userRole==Util.roles[2]){
      ref.child(id).update({
        "status": message,
        "total": total,
        "isChamado": message == StatusApp.autorizado.message ? false : true,
        "modifiedAt": DateTime.now().toString(),
      }).then((value) {
        if (message == StatusApp.autorizado.message) {
          conIp.alteraStatusIp(idIp, StatusApp.normal.message);

        } else {
          conIp.alteraStatusIp(idIp, message);
        }
      });
      await buscaPostesDefeito();
      conIp.buscaPostes();
      update();

    }
    if(userRole==Util.roles[4]){

      ref.child(id).update({
        "status": message,
        "total": total,
        "isChamado": message == StatusApp.autorizado.message ? false : true,
        "modifiedAt": DateTime.now().toString(),
        "autorizationBy":message == StatusApp.autorizado.message?userName:"",
        "autorizationAt": message == StatusApp.autorizado.message?DateTime.now().toString():"",

      }).then((value) {
        if (message == StatusApp.autorizado.message) {
          conIp.alteraStatusIp(idIp, StatusApp.normal.message);
        } else {
          conIp.alteraStatusIp(idIp, message);
        }
      });
      await buscaPostesDefeito();
      conIp.buscaPostes();

    }
    if(userRole==Util.roles[3] || userRole==Util.roles[5]){
      ref.child(id).update({
        "status": message,
        "total": total,
        "isChamado": message == StatusApp.autorizado.message ? false : true,
        "modifiedAt": DateTime.now().toString(),
        "autorizationBy":message == StatusApp.autorizado.message?userName:"",
        "autorizationAt": message == StatusApp.autorizado.message?DateTime.now().toString():"",

      }).then((value) {
        if (message == StatusApp.autorizado.message) {
          conIp.alteraStatusIp(idIp, StatusApp.normal.message);

        } else {
          conIp.alteraStatusIp(idIp, message);
        }
      });
      await buscaPostesDefeito();
      conIp.buscaPostes();
      update();

    }
  }

  alterarTotal(String id, double total) {
    ref.child(id).update({
      "total": total,
    });
  }
}
