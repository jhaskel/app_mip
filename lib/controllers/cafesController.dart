import 'dart:async';

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mip_app/repositories/cafes_repositories.dart';
import 'package:mip_app/widgets/cafe_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CafesController extends GetxController {
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;

  var valor = 2.obs;

  late StreamSubscription<Position> positionStream;
  LatLng _position = LatLng(-27.35661, -49.88283);
  late GoogleMapController _mapsController;
  final markers = Set<Marker>();

  static CafesController get to => Get.find<CafesController>();
  get mapsController => _mapsController;
  get position => _position;

  String poste = 'assets/poste.png';
  String posteQueimado = 'assets/poste-queimado.png';

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  changeValor() {
    // DB.city();
    valor.value++;
    update();
  }

  onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    getPosicao();
    loadIps();

    var style = await rootBundle.loadString('assets/map/dark.json');
    _mapsController.setMapStyle(style);
  }

  List<dynamic> list = [];
  late StreamSubscription fh;

  Stream<QuerySnapshot> myStream() {
    FirebaseFirestore db = DB.get();

    /*fh = db.collection('cities').snapshots().listen((snapshot) {
      for (DocumentSnapshot document in snapshot.docs) {
        var as = document.data();
      }
    });*/

    var fg = db.collection('cities').snapshots();

    fg.forEach((e) {
      var changes = e.docChanges;
      //   print(changes);

      e.docs.forEach((x) {
        GeoPoint point = x['position'];
        //   print(point.latitude);
        addMarcador(x);

        //addMarker(x);
      });
    });

    //  as.forEach((cafe) => addMarker(cafe));

    return fg;
  }

  addMarcador(QueryDocumentSnapshot<Map<String, dynamic>> x) {
    GeoPoint point = x.get('position');

    print(x['name']);
    String iconPoste = poste;

    print("haskel");
    markers.add(
      Marker(
        markerId: MarkerId(x.get('name')),
        position: LatLng(point.latitude, point.longitude),
        infoWindow: InfoWindow(title: x.get('name')),
        icon: x.get('capital') == true
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose)
            : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        onTap: () => showDetails(x.data()),
      ),
    );
    update();
  }

  loadIps() async {
    FirebaseFirestore db = DB.get();
    print("ipd");

    final ipss = db.collection('Ip').get().then((value) {
      value.docs.forEach((e) {
        print('dados ${e['cod']}');
      });

      for (var t in value.docs) {
        print('codigos ${t['cod']}');
      }
      print("valores ${value.docs[0].reference}");
    });

    print("ok");
    list.clear();

    print('lista parceiro $list');
    update();

    //  cafes.docs.forEach((cafe) => addMarker(cafe));
  }

  loadCafes() async {
    FirebaseFirestore db = DB.get();
    final cafes = await db.collection('cafes').get();
    cafes.docs.forEach((cafe) => addMarker(cafe));
  }

  addMarker(QueryDocumentSnapshot<Map<String, dynamic>> cafe) async {
    GeoPoint point = cafe.get('position.geopoint');
    String iconPoste = poste;
    if (cafe.get('status') == 1) {
      iconPoste = posteQueimado;
    }
    final Uint8List icon = await getBytesFromAsset(iconPoste, 30);

    markers.add(
      Marker(
        markerId: MarkerId(cafe.id),
        position: LatLng(point.latitude, point.longitude),
        infoWindow: InfoWindow(title: cafe.get('nome')),
        icon: BitmapDescriptor.fromBytes(icon),
        onTap: () => showDetails(cafe.data()),
      ),
    );
    update();
  }

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
    positionStream = Geolocator.getPositionStream().listen((Position position) {
      if (position != null) {
        latitude.value = position.latitude;
        longitude.value = position.longitude;
      }
    });
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
}
