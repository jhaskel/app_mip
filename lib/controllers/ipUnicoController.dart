import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import 'package:mip_app/global/util.dart';
import 'package:mip_app/methods/common_methods.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mip_app/widgets/ipDetails.dart';

class IpUnicoController extends GetxController {
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;

  var lati = 0.0.obs;
  var longi = 0.0.obs;
  var valor = 2.obs;
  var textPage = "Ips".obs;
  var quantIp = 0.obs;
  var quantIpNormal = 0.obs;
  var quantIpDefeito = 0.obs;
  var quantIpAgendado = 0.obs;
  var quantIpConcertando = 0.obs;
  var quantIpRealizado = 0.obs;
  var bairro = "".obs;
  var logradouro = "".obs;

  late StreamSubscription<Position> positionStream;
  LatLng position = LatLng(-27.35661, -48.88283);
  var position2 = LatLng(-27.35661, -49.88283).obs;
  late GoogleMapController _mapsController;
  final markers = Set<Marker>();



  get mapsController => _mapsController;

  TextEditingController bairroController = TextEditingController();
  TextEditingController ruaController = TextEditingController();
  TextEditingController codController = TextEditingController();
  TextEditingController tipoController = TextEditingController();
  TextEditingController potenciaController = TextEditingController();
  TextEditingController alturaController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();

  clear() {
    bairroController.clear();
    alturaController.clear();
    codController.clear();
    latController.clear();
    tipoController.clear();
    ruaController.clear();
    potenciaController.clear();
    tipoController.clear();

    update();
  }


  /**/

  LatLng? markerPosition;
  var dragged = false.obs;
  String poste = 'assets/poste.png';
  String posteQueimado = 'assets/poste-queimado.png';
  List<String> icones = [
    'assets/poste-normal.png',
    'assets/poste-defeito.png',
    'assets/poste-agendado.png',
    'assets/poste-concertando.png'
  ];

  List<dynamic> list = [].obs;
  Map maps = {};
  var textAppBar = "Postes".obs;

  final ref = FirebaseDatabase.instance.ref('Ip');

  final refPref = FirebaseDatabase.instance.ref('Prefeitura');

  var numero = ''.obs;
  var lat = ''.obs;
  var long = ''.obs;
  var status = ''.obs;
  int i = 0;
  var loading = false.obs;

  CommonMethods cMethods = CommonMethods();
  var postes = Map<String, String>().obs;
  List<dynamic> listaIp = [].obs;



  onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    getPosicao();

    var style = await rootBundle.loadString('assets/map/dark.json');
    _mapsController.setMapStyle(style);
  }


  AlteraAllStatus() async {
    list.clear();
    await ref.orderByChild('isAtivo').equalTo(true).onValue.listen((event) {
      if (event.snapshot.exists) {
        maps = event.snapshot.value as Map;
        list = maps.values.toList();

      }

    });

    for (var x in list) {

      ref.child(x['id']).update({
        "status": StatusApp.normal.message,
      });
    }

  }






  alteraStatusIp(String idIp, String status) {
    ref.child(idIp).update({
      "status": status,
    });
    update();
  }

  removeIp(String id, BuildContext context) {
    ref.child(id).remove().then((value) {
      cMethods.displaySnackBar("${textPage.value} excluido!", context);
    }).onError((error, stackTrace) {
      cMethods.displaySnackBar(
          "Não foi possivel Excluir ${textPage.value}", context);
    });
  }

  changeLat(LatLng target) {
    position2(target);
    print((position2.value));
    update();
  }
  changeLati(LatLng target) {
    position2(target);
    print((position2.value));
    update();
  }

  showDetails(ip) {
    Get.bottomSheet(
      IpDetails(
        id: ip['id'],
        status: ip['status'],
        latitude: ip['latitude'],
        longitude: ip['longitude'],
      ),
      barrierColor: Colors.transparent,
    );
  }

  watchPosicao() async {
    print("whatch");
    positionStream = Geolocator.getPositionStream().listen((Position position) {
      if (position != null) {
        latitude.value = position.latitude;
        longitude.value = position.longitude;
      }
    });

    print("latttitude ${latitude.value = position.latitude}");
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

    return await Geolocator.getCurrentPosition().then((value) => buscaPostes2());
  }

  getPosicao() async {
    try {
      final posicao = await _posicaoAtual();
      latitude.value = posicao.latitude;
      longitude.value = posicao.longitude;
      position2(LatLng(latitude.value, longitude.value));
      print("pos2 $position2");


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

  buscaPostes2() {}




}
