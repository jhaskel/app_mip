import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mip_app/controllers/ipController.dart';
import 'package:mip_app/global/util.dart';
import 'package:mip_app/methods/common_methods.dart';
import 'dart:ui' as ui;

import 'package:mip_app/pages/controle/consertando_page.dart';
import 'package:mip_app/widgets/ChamadoDetails.dart';

class ChamadoController extends GetxController {
  final ref = FirebaseDatabase.instance.ref('Chamado');
  final refIp = FirebaseDatabase.instance.ref('Ip');

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
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var lati = 0.0.obs;
  var longi = 0.0.obs;
  LatLng? markerPosition;
  var dragged = false.obs;

  List<String> icones = [
    'assets/poste-normal.png',
    'assets/poste-defeito.png',
    'assets/poste-agendado.png',
    'assets/poste-relatado.png'
  ];
  final markers = Set<Marker>().obs;
  List<dynamic> list = [].obs;

  Map maps = {};

  var postes = Map<String, dynamic>().obs;

  LatLng _position = LatLng(-27.35661, -49.88283);
  var position2 = LatLng(-27.35661, -49.88283).obs;
  late GoogleMapController _mapsController;
  static IpController get to => Get.find<IpController>();
  get mapsController => _mapsController;
  get position => _position;

  onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    getPosicao();
    buscaPostesDefeito();

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

  resetar() async {
    await refIp.orderByChild('isAtivo').equalTo(true).get().then((value) {
      Map pos = value.value as Map;
      listaChamados.clear();
      listaChamados = pos.values.toList();

      for (var x in listaChamados) {
        print(x['isAtivo']);
        if (x['status'] != "normal") {
          refIp.child(x['id']).update(
              {"status": 'normal', "modifiedAt": DateTime.now().toString()});
        }
      }
    });

    update();
  }

  void getChamados(BuildContext context) async {
    await ref.orderByChild('status').equalTo('realizado').get().then((value) {
      Map pos = value.value as Map;

      listaChamados.clear();
      listaChamados = pos.values.toList();
      print(listaChamados.length);
    });

    update();
  }

  void createChamado(BuildContext context) async {
    String id = DateTime.now().millisecondsSinceEpoch.toString();

    String ipIds = idIp.value;

    var chamado = {
      'id': id,
      'idIp': ipIds, //id do Ip
      'createdAt': DateTime.now().toString(),
      'modifiedAt': DateTime.now().toString(),
      'latitude': lati.value,
      'longitude': longi.value,
      'status': StatusApp.defeito.message,
      'defeito': defeito.value,
      'isChamado': true,
    };

    ref.child(id).set(chamado).then((value) async {
      await conIp.alteraStatusIp(ipIds, StatusApp.defeito.message);
      cMethods.displaySnackBar("Luminária adicionada!", context);

      conIp.postes.removeWhere((key, value) => key == ipIds);
    }).onError((error, stackTrace) {
      cMethods.displaySnackBar("Erro ao Luminária adicionada!", context);
    });

    Navigator.pop(context);
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
    update();
    markers.clear();

    await ref.orderByChild('isChamado').equalTo(true).onValue.listen((event) {
      if (event.snapshot.exists) {
        Map maps = event.snapshot.value as Map;
        list.clear();
        list = maps.values.toList();
        for (var x in list) {
          addMarcadorDefeito(x);
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
      ChamadoDetails(
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
      print("latis = ${lati.value}");
    });

    update();
  }

  getChamadosConcertado(BuildContext context, String stattus) async {
    listaChamados.clear();

    await ref.orderByChild('status').equalTo(stattus).onValue.listen((event) {
      listaChamados.clear();
      if (event.snapshot.exists) {
        Map maps = event.snapshot.value as Map;
        print('maps $maps');

        var list = maps.values.toList();
        list = maps.values.toList()
          ..sort(((a, b) => (a["idIp"]).compareTo((b["idIp"]))));

        for (var x in list) {
          listaChamados.add(x);
        }

        loading(false);

        update();
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

  alterarStatus(String id, String idIp, String message) {
    ref.child(id).update({
      "status": message,
      "isChamado": message == StatusApp.autorizado.message ||
              message == StatusApp.autorizado.message
          ? false
          : true,
      "modifiedAt": DateTime.now().toString()
    }).then((value) {
      if (message == StatusApp.autorizado.message) {
        conIp.alteraStatusIp(idIp, StatusApp.normal.message);
      } else {
        conIp.alteraStatusIp(idIp, message);
      }
    });

    buscaPostesDefeito();
    conIp.buscaPostes();
    update();
  }
}
