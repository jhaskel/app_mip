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

class IpController extends GetxController {
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
  LatLng _position = LatLng(-27.35661, -49.88283);
  var position2 = LatLng(-27.35661, -49.88283).obs;
  late GoogleMapController _mapsController;
  final markers = Set<Marker>();

  static IpController get to => Get.find<IpController>();

  get mapsController => _mapsController;

  get position => _position;

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
  var loading = false.obs;

  CommonMethods cMethods = CommonMethods();
  var postes = Map<String, String>().obs;
  List<dynamic> listaIp = [].obs;

  getIp() async {
    loading(true);
    await ref.get().then((value) {
      Map pos = value.value as Map;


      listaIp.clear();

      listaIp = pos.values.toList()
        ..sort(((a, b) => (a["id"]).compareTo((b["id"]))));

      quantIp(listaIp.length);
      quantIpNormal(0);
      quantIpAgendado(0);
      quantIpDefeito(0);

      for (var x in listaIp) {
        if (x['status'] == "normal") {
          postes.addAll({x['id']: x['cod']});

          quantIpNormal.value++;
        }
        if (x['status'] == "defeito") {
          quantIpDefeito.value++;
        }

        if (x['status'] == "agendado") {
          quantIpAgendado.value++;
        }
      }
    });
    loading(false);

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
    var texto = x['cod'];

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

          icon: await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(20.5, 20.5)), iconPoste),
          draggable: dragged.value,
          //  onDragEnd: (LatLng position) => _onMarkerDragEnd(markerId, position),
          //   onDrag: (LatLng position) => _onMarkerDrag(markerId, position),
          onTap: () => {showDetails(x)},
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

    return await Geolocator.getCurrentPosition().then((value) => buscaPostes());
  }

  getPosicao() async {
    try {
      final posicao = await _posicaoAtual();
      latitude.value = posicao.latitude;
      longitude.value = posicao.longitude;
      position2(LatLng(latitude.value, longitude.value));
      print("pos2 $position2");
      buscaPostes();

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

  createdIp(BuildContext context) {

    String id = DateTime.now().millisecondsSinceEpoch.toString();
   String gh = codController.text;
   var gt = gh.split(" ");
   String yu = gt[0].toLowerCase();
   String yo = gt[1];
   String cod = "${yu}${yo}";

    var ip={
      "id":cod,
      "Bairro":bairro.value,
      "logradouro":logradouro.value,
      "cod":logradouro.value,
      "cod":codController.text,
      "tipo":tipoController.text,
      "potencia":int.parse(potenciaController.text),
      "altura":int.parse(alturaController.text),
      "latitude":double.parse(latController.text),
      "longitude":double.parse(longController.text),
      "isAtivo":true,
      "createdAt":DateTime.now().toString(),
      "ModifiedAt":DateTime.now().toString(),
      "status":StatusApp.normal.message

    };
    ref.child(cod).set(ip).then((value) async {
      cMethods.displaySnackBar("IP adicionado!", context);

    }).onError((error, stackTrace) {
      cMethods.displaySnackBar("Erro ao adicionar a ip!", context);
    });
    clear();
    getIp();

    update();

    Navigator.pop(context);
  }
}
