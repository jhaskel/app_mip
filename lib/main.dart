import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:mip_app/authentication/login_screeen.dart';
import 'package:mip_app/authentication/signup_screen.dart';
import 'package:mip_app/pages/home/dashboard.dart';
import 'package:mip_app/pages/home/dashboard_anonimo.dart';

import 'package:mip_app/pages/home/home_page.dart';
import 'package:mip_app/splash.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mip_app/firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale('pt', 'BR'),
      title: 'Ilumina Braço',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
    // home: LoginScreen(),
     home: SplashScreen(),
      /*home: FirebaseAuth.instance.currentUser == null
          ? DashboardAnonimo()
         // : HomePage(),
          : Dashboard(),*/


      //home: MapsIp(),
      //  home: const LoginPage(),
    );
  }
}
