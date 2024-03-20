import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mip_app/controllers/chamadoController.dart';
import 'package:mip_app/controllers/usuarioController.dart';
import 'package:mip_app/global/app_colors.dart';
import 'package:mip_app/global/global_var.dart';

import 'package:mip_app/global/util.dart';
import 'package:mip_app/pages/controle/autorizacao_page.dart';
import 'package:mip_app/pages/chamados/create-defeito-page.dart';

import 'package:mip_app/pages/maps/mapsIp.dart';
import 'package:mip_app/pages/ordem/create_ordem_home.dart';
import 'package:mip_app/pages/ordem/ordem_page.dart';

class MapsChamadoPage extends StatefulWidget {
  const MapsChamadoPage({super.key});

  @override
  State<MapsChamadoPage> createState() => _MapsChamadoPageState();
}

class _MapsChamadoPageState extends State<MapsChamadoPage> {
  final controller = Get.put(ChamadoController());
  final conUse = Get.put(UsuarioController());

  @override
  void initState() {
    super.initState();
    // controller.buscaPostesDefeito();
  }

  late GoogleMapController con;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: userRole==''|| userRole==Util.roles[0]
            ?AppBar(title: Text("Postes com Defeito"),)
            :AppBar(
          title: Text("Postes com Defeito"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MapsIp()),
                  );
                },
                icon: Icon(Icons.add)),


         userRole==Util.roles[4]||userRole==Util.roles[5]?IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateOrdemHome()),
                  );
                },
                icon: Icon(Icons.table_chart)):Container(),


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
          child: GetBuilder<ChamadoController>(
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
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(StatusApp.defeito.message)
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
                              const Icon(
                                Icons.circle,
                                color: Colors.amber,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Concertado')
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

                          controller.buscaPostesDefeito();
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
                      : Center()
                ]);
              }),
        )
      ],
    );
  }
}
