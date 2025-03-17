import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mip_app/controllers/chamadoController.dart';
import 'package:mip_app/global/util.dart';
import 'package:mip_app/widgets/ChamadoBottonSheet.dart';

import 'package:mip_app/widgets/ipDetails.dart';

class mapsPageController extends GetxController {
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  LatLng _position = LatLng(-27.358057, -49.883445);
  get position => _position;
  late GoogleMapController _mapsController;
  final zoom = 16.0.obs;
  final Completer<GoogleMapController> controller =
      Completer<GoogleMapController>();
  final markers = Set<Marker>();
  StreamSubscription<Position>? positionStream;
  var loading = false.obs;
  List<dynamic> list = [].obs;
  Map maps = {};
  final ref = FirebaseDatabase.instance.ref('Ip');
  late GoogleMapController con;

  final ChamadoController conCha = Get.put(ChamadoController());
  List<String> icones = [
    'assets/poste-normal.png',
    'assets/poste-defeito.png',
    'assets/poste-agendado.png',
    'assets/poste-concertando.png',
    'assets/poste-consertado.png',
  ];

  addMarcador() async {
    String id = DateTime.now().microsecondsSinceEpoch.toString();

    final MarkerId markerId = MarkerId(id);

    markers.add(
      Marker(
        markerId: markerId,
        position: position,
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    update();
  }

  addPostes(x) async {
    String iconPoste = icones[0];
    String id = DateTime.now().microsecondsSinceEpoch.toString();
    print("stringy $id");
    final MarkerId markerId = MarkerId(x['cod']);
    if (x['status'] == StatusApp.normal.message) {
      iconPoste = icones[0];
    } else if (x['status'] == StatusApp.defeito.message) {
      iconPoste = icones[1];
    } else if (x['status'] == StatusApp.agendado.message) {
      iconPoste = icones[2];
    } else if (x['status'] == StatusApp.concertando.message) {
      iconPoste = icones[3];
    } else if (x['status'] == StatusApp.concertado.message) {
      iconPoste = icones[4];
    } else {
      iconPoste = icones[0];
    }

    markers.add(
      Marker(
        markerId: markerId,
        position: LatLng(x['latitude'], x['longitude']),
        infoWindow: InfoWindow(title: '${x['id']}'),
        icon: await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(20.5, 20.5)), iconPoste),
        onTap: () async {
          await conCha.getChamadosByIp(x['id']);

          Future.delayed(Duration(milliseconds: 300), () {
            if(conCha.listChamadosByIP.isEmpty){
              showDetails(x);
            }else{


              var Chamado = conCha.listChamadosByIP.first;
              print("akix ${Chamado['status']}");
              if (Chamado['status'] == 'concluido'||Chamado['status'] == 'lancado') {

                showDetails(x);
              }else{

                bottonSheet(conCha.listChamadosByIP);
              }
            }
          });



        },
      ),
    );

    update();
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

  changeZoom() {
    zoom(zoom.value + 1);

    update();
  }

  changePosition(LatLng pos) {
    _position = pos;

    addMarcador();

    update();
  }

  onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    getPosicao();
  }

  Future<void> goToTheLake() async {
    con = await controller.future;
    await con.animateCamera(CameraUpdate.newCameraPosition(kLake));
  }

  Future<void> goToNovaPosicao() async {
    con = await controller.future;
    await con.animateCamera(CameraUpdate.newLatLng(position));
  }

  CameraPosition kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(-28.358057, -50.883445),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  watchPosicao() async {
    positionStream = Geolocator.getPositionStream().listen((Position position) {
      if (position != null) {
        latitude.value = position.latitude;
        longitude.value = position.longitude;
      }
    });
  }

  @override
  void onClose() {
    positionStream!.cancel();
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

    //return await Geolocator.getCurrentPosition().then((value) => buscaPostes());

   // buscaPostes();
    return await Geolocator.getCurrentPosition();
  }

  buscaPostes() async {
    try {
      loading(true);
      markers.clear();
      list.clear();
      await ref.orderByChild('isAtivo').equalTo(true).onValue.listen((event) {
        if (event.snapshot.exists) {
          maps = event.snapshot.value as Map;
          list = maps.values.toList();

          for (var x in list) {
            addPostes(x);
          }
        }
      });
      loading(false);

      update();
    } catch (e) {
      print("errro $e");
    }
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
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  clear() {
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

  @override
  void dispose() {
    super.dispose();
    positionStream?.cancel();
  }
}
