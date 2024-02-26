import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:firebase_database/firebase_database.dart';
import 'package:mip_app/controllers/chamadoController.dart';
import 'package:mip_app/widgets/adicionarDefeito.dart';
import 'package:mip_app/widgets/defeitos_list.dart';
import 'package:mip_app/global/util.dart';
import 'package:mip_app/methods/common_methods.dart';
import 'package:mip_app/widgets/cafe_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mip_app/widgets/ipDetails.dart';

class IpController extends GetxController {
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;

  var lati = 0.0.obs;
  var longi = 0.0.obs;
  var valor = 2.obs;
  var textPage = "Ips".obs;

  late StreamSubscription<Position> positionStream;
  LatLng _position = LatLng(-27.35661, -49.88283);
  var position2 = LatLng(-27.35661, -49.88283).obs;
  late GoogleMapController _mapsController;
  final markers = Set<Marker>();

  static IpController get to => Get.find<IpController>();

  get mapsController => _mapsController;

  get position => _position;

  /**/

  LatLng? markerPosition;
  var dragged = false.obs;
  String poste = 'assets/poste.png';
  String posteQueimado = 'assets/poste-queimado.png';
  List<String> icones = [
    'assets/poste-normal.png',
    'assets/poste-defeito.png',
    'assets/poste-agendado.png',
    'assets/poste-relatado.png'
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

  CommonMethods cMethods = CommonMethods();
  var postes = Map<String, String>().obs;
  List<dynamic> listaIp = [].obs;



  getIp() async {
    await ref.orderByChild('status').equalTo('normal').get().then((value) {
      Map pos = value.value as Map;
      final sorted = Map.fromEntries(
          pos.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));

      listaIp.clear();
      listaIp = sorted.values.toList();

      for (var x in listaIp) {
        if (x['status'] != "defeito") {
          postes.addAll({x['id']: x['cod']});
        }
      }
    });

    update();
  }

  onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    getPosicao();
    buscaPostes();
    var style = await rootBundle.loadString('assets/map/dark.json');
    _mapsController.setMapStyle(style);
  }

  buscaPostes() async {

    loading(true);
      update();

    markers.clear();
    list.clear();
    await ref.orderByChild('isAtivo').equalTo(true).onValue.listen((event) {
      if (event.snapshot.exists) {
        maps = event.snapshot.value as Map;
        list = maps.values.toList();


        for (var x in list) {
          loading(true);
          addMarcador(x);

        }
        loading(false);

        update();
      }
    });


  }

  addMarcador(x) async {
    String iconPoste = icones[0];
    var texto = "pra frente";

    double eixoLat = 0.008529;
    double eixoLong = 0.004324;

    double boundLatNo = position2.value.latitude + eixoLat;
    double boundLongNo = position2.value.longitude + eixoLong;
    double boundLatSu = position2.value.latitude - eixoLat;
    double boundLongSu = position2.value.longitude - eixoLong;

    var latitudeMarcador = x['latitude'];
    var longitudeMarcador = x['longitude'];

    if (latitudeMarcador > boundLatSu &&
        latitudeMarcador < boundLatNo &&
        longitudeMarcador > boundLongSu &&
        longitudeMarcador < boundLongNo) {
      final MarkerId markerId = MarkerId(x['cod']);
      if (x['status'] == StatusApp.normal.message) {
        iconPoste = icones[0];
      } else if (x['status'] == StatusApp.defeito.message) {
        iconPoste = icones[1];
      } else if (x['status'] == StatusApp.agendado.message) {
        iconPoste = icones[2];
      } else {
        iconPoste = icones[3];
      }


      markers.add(
        Marker(
          markerId: markerId,
          position: LatLng(x['latitude'], x['longitude']),
          infoWindow: InfoWindow(title: texto),

          icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(20.5,20.5)), iconPoste),
          draggable: dragged.value,
          //  onDragEnd: (LatLng position) => _onMarkerDragEnd(markerId, position),
          //   onDrag: (LatLng position) => _onMarkerDrag(markerId, position),
          onTap: () => {

            showDetails(x)
          },
        ),
      );
      update();
    } else {
      markers.clear();
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

  var loading = false.obs;

  changeLat(LatLng target) {
    position2(target);
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

    return await Geolocator.getCurrentPosition();
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

  toggleDraggable() async {
    dragged(!dragged.value);
    print(dragged.value);

    update();
  }

  Future<void> _onMarkerDrag(MarkerId markerId, LatLng newPosition) async {
    markerPosition = newPosition;
    //  _position2 = markerPosition;

    update();
  }

  final Marker? tappedMarker = null;

  Future<void> _onMarkerDragEnd(MarkerId markerId, LatLng newPosition) async {
    markerPosition = null;
    print(newPosition);
    update();
  }

  void addMarc() {}
}
