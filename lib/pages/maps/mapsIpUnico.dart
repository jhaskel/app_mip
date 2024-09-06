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
    controller.latitude.value = item['latitude'];
    controller.longitude.value = item['longitude'];
    controller.position=LatLng(item['latitude'], item['longitude']);
  }



  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: _body(),
      ),
    );
  }

  _body() {
    return Column(
      children: [
        Expanded(
          child: GetBuilder<IpUnicoController>(
              init: controller,
              builder: (value) {
                return Stack(children: [
                  GoogleMap(
                    mapType: MapType.hybrid,
                    zoomControlsEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: controller.position,
                      zoom: 16,
                    ),
                    onMapCreated: controller.onMapCreated,
                    myLocationEnabled: true,
                    markers: {
                      Marker(
                        markerId: MarkerId('01'),
                        position: controller.position,
                      )
                    },

                    onCameraMove: ((position) =>      print(position)),
                    onTap: (pos) {
                      controller.changeLat(pos);
                    },
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
              }),
        )
      ],
    );
  }
}
