import 'package:mip_app/maps/animate_camera.dart';
import 'package:mip_app/pages/cadastro/create-defeito-page.dart';
import 'package:mip_app/pages/dashboard.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:mip_app/pages/maps/mapsIp.dart';
import 'package:mip_app/pages/firestorePage.dart';
import 'package:mip_app/pages/home_main.dart';
import 'package:mip_app/pages/maps/MapsChamadoPage.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:mip_app/controllers/loginControllers.dart';
import 'package:mip_app/firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("passou1");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kIsWeb) {
  } else {
    await FlutterConfig.loadEnvVariables();

    await Permission.locationWhenInUse.isDenied.then((valueOfPermission) {
      if ((valueOfPermission)) {
        Permission.locationWhenInUse.request();
      }
    });
  }

  print("passou3");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print("passou");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginContoller())
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CoMip',
        theme: ThemeData.dark(
          useMaterial3: true,
        ),
        //   home: HomeMain(),
        //  home: DatabasePage(),
        home: MapsChamadoPage(),
        //  home: const LoginPage(),
      ),
    );
  }
}
