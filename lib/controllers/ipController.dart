import 'dart:async';

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:firebase_database/firebase_database.dart';
import 'package:mip_app/global/util.dart';
import 'package:mip_app/methods/common_methods.dart';

import 'package:mip_app/widgets/cafe_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class IpController extends GetxController {
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
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

  var isNormal = true.obs;
  CommonMethods cMethods = CommonMethods();

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  var postes = Map<String, String>().obs;
  List<dynamic> listaIp = [].obs;

  getIp() async {
    await ref.orderByChild('status').equalTo('normal').get().then((value) {
      Map pos = value.value as Map;
      listaIp.clear();
      listaIp = pos.values.toList();
      listaIp = maps.values.toList()
        ..sort(((a, b) => (a["cod"]).compareTo((b["cod"]))));
      for (var x in listaIp) {
        if (x['status'] != "defeito") {
          postes.addAll({x['id']: x['cod']});
        }
      }
    });

    update();
  }

  getIpUnico(String id) async {
    await ref.child(id).get().then((value) {
      Map ips = value.value as Map;
      var status = "";

      if (status == "defeito") {
        isNormal(false);
      }
    });

    update();
  }

  changeValor() {
    // DB.city();
    valor.value++;
    update();
  }

  onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    getPosicao();
    buscaPostes();
    //centerBound();
    // buscaPosteStream();
    print("teste");

    var style = await rootBundle.loadString('assets/map/dark.json');
    _mapsController.setMapStyle(style);
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
      final Uint8List icon = await getBytesFromAsset(iconPoste, 35);

      markers.add(
        Marker(
          markerId: markerId,
          position: LatLng(x['latitude'], x['longitude']),
          infoWindow: InfoWindow(title: texto),
          icon: BitmapDescriptor.fromBytes(icon),
          //   icon: BitmapDescriptor.defaultMarker,
          draggable: dragged.value,
          //  onDragEnd: (LatLng position) => _onMarkerDragEnd(markerId, position),
          //   onDrag: (LatLng position) => _onMarkerDrag(markerId, position),
          onTap: () => {
            Get.bottomSheet(
              Container(
                  color: Colors.white,
                  height: 300,
                  width: 500,
                  child: Text(
                    "ops ${x['status']}",
                    style: TextStyle(color: Colors.black),
                  )),
              barrierColor: Colors.transparent,
            )
          },
        ),
      );
    } else {
      markers.clear();
    }

    update();
  }

  addMarcador2(x) async {
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
    final MarkerId markerId = MarkerId(x['cod']);
    markers.add(
      Marker(
        markerId: markerId,
        position: LatLng(x['latitude'], x['longitude']),
        infoWindow: InfoWindow(title: markerId.toString()),
        icon: BitmapDescriptor.fromBytes(icon),
        //  icon: BitmapDescriptor.defaultMarker,
        draggable: dragged.value,
        //  onDragEnd: (LatLng position) => _onMarkerDragEnd(markerId, position),
        //   onDrag: (LatLng position) => _onMarkerDrag(markerId, position),
        onTap: () => {
          Get.bottomSheet(
            Container(
                color: Colors.white,
                height: 300,
                width: 500,
                child: Text(
                  "ops ${x['status']}",
                  style: TextStyle(color: Colors.black),
                )),
            barrierColor: Colors.transparent,
          )
        },
      ),
    );

    update();
  }

  alteraStatusIp(BuildContext context, String idIp) {
    ref.child(idIp).update({
      "status": StatusApp.defeito.message,
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

  buscaPostes() async {
    print("load ${position2.value}");
    loading(true);
    update();
    String statuss = 'defeito';

    markers.clear();
    await ref
        // .orderByChild('status')
        //   .equalTo(statuss)
        // .limitToLast(5)
        .onValue
        .listen((event) {
      maps = event.snapshot.value as Map;
      list.clear();

      list = maps.values.toList();
    });

    int i = 0;

    for (var x in list) {
      if (x['status'] != StatusApp.normal.message) {
        addMarcador2(x);
      }

      i++;
      //   print("iiiii $i");
    }

    loading(false);
    update();
  }

  //hjdfyh7gsh1

  showDetails(cafe) {
    String imagem =
        "https://static.vecteezy.com/system/resources/thumbnails/004/141/669/small/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not-available-or-image-coming-soon-sign-simple-nature-silhouette-in-frame-isolated-illustration-vector.jpg";
    print("cafe imag ${cafe['imagem']}");
    if (cafe['imagem'] != null) {
      print("tem");
      imagem = cafe['imagem'];
    }
    Get.bottomSheet(
      CafeDetails(
        nome: cafe['nome'],
        imagem: cafe['imagem'],
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
