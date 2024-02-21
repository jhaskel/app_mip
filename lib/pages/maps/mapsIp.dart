import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mip_app/controllers/ipController.dart';
import 'package:mip_app/repositories/cafes_repositories.dart';

class MapsIp extends StatefulWidget {
  const MapsIp({super.key});

  @override
  State<MapsIp> createState() => _MapsIpState();
}

class _MapsIpState extends State<MapsIp> {
  final controller = Get.put(IpController());

  @override
  void initState() {
    super.initState();
    //  controller.buscaPostes(context);
  }

  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(-33.852, 151.211),
    zoom: 11.0,
  );
  CameraPosition _position = _kInitialPosition;
  late GoogleMapController con;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Postes")),
        body: _body(),
      ),
    );
    /*  return StreamBuilder(
        stream: controller.event(),
        builder: (context, snapshot) {
          Map<dynamic, dynamic> maps = snapshot.data!.snapshot.value as Map;
          List<dynamic> list = [];
          list.clear();
          list = maps.values.toList();
          controller.dispara(list);
          return Scaffold(
            appBar: AppBar(
              title: Obx(() => Text(controller.textAppBar.value)),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.accessibility,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    controller.changeValor();
                  },
                ),
              ],
            ),
            body: _body(controller, list),
          );
        });*/
  }

  _body() {
    return Column(
      children: [
        Expanded(
          child: GetBuilder<IpController>(
              init: controller,
              builder: (value) {
                return Stack(children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    zoomControlsEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: controller.position,
                      zoom: 16,
                    ),
                    onMapCreated: controller.onMapCreated,
                    myLocationEnabled: true,
                    markers: controller.markers,
                    onCameraMove: (pos) {},
                    onTap: (pos) {
                      controller.changeLat(pos);
                      for (var k in controller.list) {
                        controller.addMarcador(k);
                      }
                    },
                  ),
                  Positioned(
                      top: 50,
                      right: 50,
                      child: IconButton(
                        onPressed: () {
                          controller.toggleDraggable();
                        },
                        icon: Icon(Icons.read_more),
                      )),
                  Positioned(
                      top: 20,
                      left: 20,
                      child: IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () {
                          controller.markers.clear();

                          for (var k in controller.list) {
                            controller.addMarcador(k);
                          }
                          //  controller.buscaPostes();
                        },
                      )),
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
