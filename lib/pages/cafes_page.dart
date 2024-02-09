import 'package:mip_app/controllers/cafesController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CafesPage extends StatelessWidget {
  CafesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CafesController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Cafés'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              controller.changeValor();
            },
          ),
        ],
      ),
      body: _body(controller),
    );
  }

  GetBuilder<CafesController> _body(CafesController controller) {
    return GetBuilder<CafesController>(
        init: controller,
        builder: (value) {
          return GoogleMap(
            mapType: MapType.normal,
            zoomControlsEnabled: true,
            initialCameraPosition: CameraPosition(
              target: controller.position,
              zoom: 13,
            ),
            onMapCreated: controller.onMapCreated,
            myLocationEnabled: true,
            markers: controller.markers,
          );
        });
  }
}
