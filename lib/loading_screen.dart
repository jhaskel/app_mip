

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/gpsController.dart';
import 'package:mip_app/gps_access_screen.dart';
import 'package:mip_app/pages/maps/mapsPage.dart';
import 'package:mip_app/splash.dart';



class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  final controller = Get.put(GpsConstroller());
  @override
  Widget build(BuildContext context) {

    if (kIsWeb) {
    return SplashScreen();

    } else {
      return Obx(
            ()=>Scaffold(
            appBar: AppBar(title: Text('${controller.text.value}'),),
            body:  controller.isAllPermissionGranted==true
                ? MapsPage()
                :GpsAccessScreen()



        ),
      );

    }



  }
}
