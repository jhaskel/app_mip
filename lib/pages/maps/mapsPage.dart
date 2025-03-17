import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_picker/map_picker.dart';
import 'package:mip_app/controllers/loginControllers.dart';
import 'package:mip_app/controllers/mapsPageController.dart';
import 'package:mip_app/controllers/usuarioController.dart';
import 'package:mip_app/global/util.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => MapsPageState();
}

class MapsPageState extends State<MapsPage> {

  final conMaps = Get.put(mapsPageController());
  final conUser = Get.put(UsuarioController());
  MapPickerController mapPickerController = MapPickerController();
  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(-27.36121364945277, -49.879652892549075),
    zoom: 14.4746,
  );

  var textController = TextEditingController();

@override
  void initState() {

  conMaps.buscaPostes();

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          conUser.roleUsuario=='master'?IconButton(
              onPressed: () {
                conMaps.AlteraAllStatus();
              },
              icon: Icon(Icons.edit_document)):Container()
        ],
        title:  Text(''),



      ),
      body: GetBuilder<mapsPageController>(

        builder: (logic) {
          return Stack(
            children: [
              MapPicker(
                iconWidget: SvgPicture.asset(
                  "assets/location_icon.svg",
                  height: 60,
                ),
                mapPickerController: mapPickerController,

                child: GoogleMap(
                
                  zoomControlsEnabled: false,
                  mapType: MapType.hybrid,
                  initialCameraPosition: CameraPosition(
                
                    target: conMaps.position,
                    zoom: conMaps.zoom.value,
                  ),
                  onTap: (pos) {
                  //  conMaps.changePosition(pos);
                  },
                  onMapCreated: conMaps.onMapCreated,
                  markers: conMaps.markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onCameraMoveStarted: () {
                    // notify map is moving
                    mapPickerController.mapMoving!();

                  },
                  onCameraMove: (cameraPosition) {
                   this.cameraPosition = cameraPosition;
                   textController.text = cameraPosition.target.latitude.toString();
                  },
                
                ),
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
                            color: Colors.yellow,
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
                            color: Colors.deepOrange,
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
                top: MediaQuery.of(context).viewPadding.top + 20,
                width: MediaQuery.of(context).size.width - 50,
                height: 50,
                child: TextFormField(
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  readOnly: true,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero, border: InputBorder.none),
                  controller: textController,
                ),
              ),

              Positioned(
                bottom: 24,
                left: 24,
                right: 24,
                child: SizedBox(
                  height: 50,
                  child: TextButton(
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        color: Color(0xFFFFFFFF),
                        fontSize: 19,
                        // height: 19/19,
                      ),
                    ),
                    onPressed: () {
                      print(
                          "Location ${cameraPosition.target.latitude} ${cameraPosition.target.longitude}");

                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFFA3080C)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                ),
              )


            ],
          );
        },
      ),

    );
  }


}