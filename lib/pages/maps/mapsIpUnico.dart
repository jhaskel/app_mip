import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mip_app/controllers/ipController.dart';
import 'package:mip_app/controllers/ipUnicoController.dart';
import 'package:mip_app/pages/chamados/chamados_page.dart';
import 'package:mip_app/pages/ip/ip_page.dart';


class MapsIpUnico extends StatefulWidget {
  dynamic item;
  MapsIpUnico(this.item, {super.key});



  @override
  State<MapsIpUnico> createState() => _MapsIpUnicoState();
}

class _MapsIpUnicoState extends State<MapsIpUnico> {
  final controller = Get.put(IpUnicoController());
  get item => widget.item;
  @override
  void initState() {
    super.initState();
    //  controller.buscaPostes(context);
  }

  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(-33.852, 151.211),
    zoom: 15.0,
  );


  CameraPosition _position = _kInitialPosition;
  late GoogleMapController con;
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: _body(),
      ),
    );
  }

  _body() {
    return Stack(children: [
      GoogleMap(
        mapType: MapType.hybrid,
        zoomControlsEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(item['latitude'],item['longitude']),
          zoom: 17,
        ),

        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        markers: { Marker(
    markerId: MarkerId('001'),
    position: LatLng(item['latitude'],item['longitude']),
           infoWindow: InfoWindow(
          title: "${item['id']}",
          snippet: "${item['status']}",
      ), // Inf

    )}


      ),


      controller.loading == true
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("carregando marcadores...."),
            CircularProgressIndicator(),
          ],
        ),
      )
          : Container()
    ]);
  }



}
