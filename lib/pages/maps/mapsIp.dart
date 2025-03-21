import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mip_app/controllers/ipController.dart';
import 'package:mip_app/pages/chamados/chamados_page.dart';
import 'package:mip_app/pages/ip/ip_page.dart';


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
  }

  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(-27, -49),
    zoom: 11.0,
  );



  @override
  Widget build(BuildContext context) {
    print("bandido");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Postes"),
          actions: [
            IconButton(
                onPressed: () {
                  push(context, IpPage());
                },
                icon: Icon(Icons.post_add)),
            IconButton(
                onPressed: () {
                  push2(context, ChamadosPage());
                },
                icon: Icon(Icons.baby_changing_station)),
            IconButton(
                onPressed: () {
                  controller.AlteraAllStatus();
                },
                icon: Icon(Icons.edit_document))
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
                print("builderx");
                return Stack(children: [
                  Obx(
                    ()=> GoogleMap(

                      mapType: MapType.satellite,
                      zoomControlsEnabled: controller.zoomControlsEnabled.value,
                      initialCameraPosition: CameraPosition(
                        target: controller.position,
                        zoom: controller.zoom.value,
                      ),
                      onMapCreated: controller.onMapCreated,
                      myLocationEnabled: true,
                      markers: controller.markers,
                      onCameraMove: (pos) {},
                      onLongPress: (pos){
                        print("lats");
                        print('latitude ${pos.latitude}');
                      },
                      onTap: (pos) async {
                        print('latitude ${pos.latitude}');
                        await controller.changeLat(pos);
                        for (var k in controller.list) {
                          controller.addMarcador(k);
                        }
                      },
                    ),
                  ),
                  Positioned(
                      top: 50,
                      right: 100,
                      child: IconButton(
                        onPressed: () {
                          print("doops");
                          controller.changeZoom();
                        },
                        icon: Icon(Icons.face),
                      )),
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

  void push(
    BuildContext context,
    IpPage page,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void push2(
    BuildContext context,
    ChamadosPage page,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
