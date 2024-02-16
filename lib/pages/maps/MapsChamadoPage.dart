import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mip_app/controllers/ipController.dart';
import 'package:mip_app/global/util.dart';
import 'package:mip_app/pages/cadastro/create-defeito-page.dart';
import 'package:mip_app/repositories/cafes_repositories.dart';

class MapsChamadoPage extends StatefulWidget {
  const MapsChamadoPage({super.key});

  @override
  State<MapsChamadoPage> createState() => _MapsChamadoPageState();
}

class _MapsChamadoPageState extends State<MapsChamadoPage> {
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
        bottomSheet: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreateDefeitoPage()),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            color: Colors.amber,
            child: Center(
                child: Text(
              "Cadastrar defeito",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )),
          ),
        ),
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
                  Positioned(
                      top: 100,
                      right: 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: Colors.amber,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(StatusApp.normal.message)
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: Colors.green,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(StatusApp.concertando.message)
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: Colors.blue,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(StatusApp.agendado.message)
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(StatusApp.defeito.message)
                            ],
                          ),
                        ],
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
