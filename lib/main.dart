import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:mip_app/loading_screen.dart';
import 'package:mip_app/pages/maps/mapsIp.dart';
import 'package:mip_app/pages/maps/mapsPage.dart';

import 'package:mip_app/splash.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mip_app/firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'mp/maps.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kIsWeb) {
  } else {

    await Permission.locationWhenInUse.isDenied.then((valueOfPermission) {
      if ((valueOfPermission)) {
        Permission.locationWhenInUse.request();
      }
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      locale: Locale(
          'pt-br', 'BR'), // translations will be displayed in that locale
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),

      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.space): ActivateIntent(),
      },
      debugShowCheckedModeBanner: false,

      title: 'Ilumina Braço',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),

     home: LoadingScreen(),
   //  home: MyHomePage(),

    );
  }
}
