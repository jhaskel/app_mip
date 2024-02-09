import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mip_app/controllers/cafesController.dart';
import 'package:mip_app/repositories/cafes_repositories.dart';

class FirestorePage extends StatefulWidget {
  const FirestorePage({super.key});

  @override
  State<FirestorePage> createState() => _FirestorePageState();
}

class _FirestorePageState extends State<FirestorePage> {
  final controller = Get.put(CafesController());
  final db = DB.get();

  @override
  void initState() {
    super.initState();
    controller.myStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cafés2'),
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
        body: _body(controller));
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

  _body0(CafesController controller) {
    return Expanded(
      child: Container(
        width: 400,
        height: 400,
        child: StreamBuilder<QuerySnapshot>(
            stream: controller.myStream(),
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                print("error");
              }
              if (snapshot.hasData) {
                var t = snapshot.data?.docs;

                print("t ${t?.length}");

                return ListView.builder(
                    itemCount: t!.length,
                    itemBuilder: (context, index) {
                      final nome = t[index]['name'];
                      final regiao = t[index]['regions'][0];
                      bool capital = t[index]['capital'];

                      return _body(controller);
                      /*  return Row(
                            children: [
                              Container(
                                height: 10,
                                width: 10,
                                color: capital ? Colors.green : Colors.grey,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(nome),
                              SizedBox(
                                width: 10,
                              ),
                              Text(regiao)
                            ],
                          );*/
                    });
              } else {
                print('nullllll');
                return Container();
              }
            }),
      ),
    );
  }
}
