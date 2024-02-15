import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mip_app/controllers/ipController.dart';
import 'package:mip_app/repositories/cafes_repositories.dart';

LatLngBounds bounds = LatLngBounds(
  southwest: LatLng(-27.361977, -49.877825),
  northeast: LatLng(-27.368034, -49.873015),
);
LatLng centerBounds = LatLng(
    (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
    (bounds.northeast.longitude + bounds.southwest.longitude) / 2);

class DatabasePage extends StatefulWidget {
  const DatabasePage({super.key});

  @override
  State<DatabasePage> createState() => _DatabasePageState();
}

class _DatabasePageState extends State<DatabasePage> {
  final controller = Get.put(IpController());
  final db = DB.get();

  CameraTargetBounds _cameraTargetBounds = CameraTargetBounds.unbounded;

  @override
  void initState() {
    super.initState();
    controller.buscaPostes();
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

  Widget _latLngBoundsToggler() {
    return TextButton(
      child: Text(
        _cameraTargetBounds.bounds == null
            ? 'bound camera target'
            : 'release camera target',
      ),
      onPressed: () {
        setState(() {
          _cameraTargetBounds = _cameraTargetBounds.bounds == null
              ? CameraTargetBounds(bounds)
              : CameraTargetBounds.unbounded;
        });
      },
    );
  }

  _body() {
    print("latlng1");
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
                    cameraTargetBounds: _cameraTargetBounds,
                    onMapCreated: controller.onMapCreated,
                    myLocationEnabled: true,
                    markers: controller.markers,
                    onCameraMove: (position) {
                      setState(() {
                        _position = position;
                      });
                      controller.changeLat(position.target);
                    },
                  ),
                  _latLngBoundsToggler(),
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

                          controller.buscaPostes();
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
