import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mip_app/controllers/chamadoController.dart';

import 'package:mip_app/global/util.dart';
import 'package:mip_app/pages/autorizacao/autorizacao_page.dart';
import 'package:mip_app/pages/cadastro/create-defeito-page.dart';
import 'package:mip_app/pages/controle/controle_page.dart';
import 'package:mip_app/pages/maps/mapsIp.dart';
import 'package:mip_app/pages/ordem/create_ordem_Itens.dart';
import 'package:mip_app/pages/ordem/create_ordem_home.dart';
import 'package:mip_app/pages/ordem/ordem_page.dart';

class MapsChamadoPage extends StatefulWidget {
  const MapsChamadoPage({super.key});

  @override
  State<MapsChamadoPage> createState() => _MapsChamadoPageState();
}

class _MapsChamadoPageState extends State<MapsChamadoPage> {
  final controller = Get.put(ChamadoController());

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
        appBar: AppBar(
          title: Text("maps"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MapsIp()),
                  );
                },
                icon: Icon(Icons.add)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ControlePage()),
                  );
                },
                icon: Icon(Icons.list)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AutorizacaoPage()),
                  );
                },
                icon: Icon(Icons.ac_unit_outlined)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateOrdemHome()),
                  );
                },
                icon: Icon(Icons.savings_outlined)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OrdemPage()),
                  );
                },
                icon: Icon(Icons.public_off_sharp)),
          ],
        ),
        body: _body(),
        bottomNavigationBar: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: InkWell(
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
                "Cadastrar defeito em Poste",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )),
            ),
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
                      top: 20,
                      right: 20,
                      child: IconButton(
                        icon: Icon(Icons.offline_bolt),
                        onPressed: () {
                          controller.resetar();
                        },
                      )),
                  Positioned(
                      top: 100,
                      right: 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
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
