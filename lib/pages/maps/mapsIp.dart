import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mip_app/controllers/ipController.dart';
import 'package:mip_app/pages/chamados/ip_page.dart';

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
        appBar: AppBar(
          title: Text("Postes"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IpPage()),
                  );
                },
                icon: Icon(Icons.post_add))
          ],
        ),
        body: _body(),
      ),
    );
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
