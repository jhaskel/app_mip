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
  String poste = 'assets/poste.png';

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

  late StreamSubscription<Position> positionStream;
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

  @override
  void onClose() {
    positionStream.cancel();
    super.onClose();
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
      'latitude': lati.value,
      'longitude': longi.value,
      'status': StatusApp.defeito.message,
      'defeito': defeito.value,
      'isChamado': true,
    };
    ref.child(id).set(chamado).then((value) async {
      await conIp.alteraStatusIp(ipId, StatusApp.defeito.message);
      cMethods.displaySnackBar("Luminária adicionada!", context);
      loading(false);
      print("codIp ${ipId}");

      conIp.postes.removeWhere((key, value) => key == ipId);
    }).onError((error, stackTrace) {
      cMethods.displaySnackBar("Erro ao Luminária adicionada!", context);
      loading(false);
    });
    clear();

    Navigator.pop(context);
    buscaPostesDefeito();

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

  buscaPostesDefeito() async {
    loading(true);
    update();

    markers.clear();

    await ref.orderByChild('isChamado').equalTo(true).onValue.listen((event) {
      if (event.snapshot.exists) {
        Map maps = event.snapshot.value as Map;
        list.clear();
        list = maps.values.toList();

        int i = 0;

        for (var x in list) {
          addMarcadorDefeito(x);

          i++;
        }
      }
    });

    loading(false);
    update();
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

    final Uint8List icon = await getBytesFromAsset(iconPoste, 35);
    final MarkerId markerId = MarkerId(x['idIp']);
    markers.add(
      Marker(
        markerId: markerId,
        position: LatLng(x['latitude'], x['longitude']),
        infoWindow: InfoWindow(title: x['defeito']),
        icon: BitmapDescriptor.fromBytes(icon),
        //  icon: BitmapDescriptor.defaultMarker,
        draggable: dragged.value,
        //  onDragEnd: (LatLng position) => _onMarkerDragEnd(markerId, position),
        //   onDrag: (LatLng position) => _onMarkerDrag(markerId, position),
        onTap: () => {bottonSheet(x)},
      ),
    );

    update();
  }

  Future<dynamic> bottonSheet(x) async {
    return Get.bottomSheet(
      Container(
          color: Colors.white,
          height: 300,
          width: 500,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Defeito : ${x['defeito']}",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Row(
                children: [
                  MaterialButton(
                    onPressed: () async {
                      await alterarStatus(x, StatusApp.agendado.message);
                      Get.back();
                    },
                    color: Colors.blue,
                    child: Text(
                      "Agendar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      await alterarStatus(x, StatusApp.normal.message);
                      Get.back();
                    },
                    color: Colors.amber,
                    child: Text(
                      "Normal",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      await alterarStatus(x, StatusApp.defeito.message);
                      Get.back();
                    },
                    color: Colors.red,
                    child: Text(
                      "Defeito",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      await alterarStatus(x, StatusApp.concertando.message);
                      Get.back();
                    },
                    color: Colors.green,
                    child: Text(
                      "Consertar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          )),
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

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  clear() {
    idIp("");
    codIp("");
    loading(false);
    defeito("");
    indexDefeito(100);
    defeito("");
    update();
  }

  alterarStatus(x, String message) {
    ref.child(x['id']).update({
      "status": message,
      "isChamado": message != 'normal' ? true : false,
      "modifiedAt": DateTime.now().toString()
    }).then((value) => conIp.alteraStatusIp(x['idIp'], message));
    buscaPostesDefeito();
    update();
  }
}
