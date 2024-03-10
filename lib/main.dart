import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:mip_app/exportPage.dart';
import 'package:mip_app/pages/chamados/chamados_page.dart';
import 'package:mip_app/pages/ip/ip_page.dart';

import 'package:mip_app/pages/maps/MapsChamadoPage.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:mip_app/controllers/loginControllers.dart';
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
    print("passou");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginContoller())
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        locale: Locale('pt', 'BR'),
        title: 'CoMip',
        theme: ThemeData.dark(
          useMaterial3: true,
        ),

        home: MapsChamadoPage(),
        //home: IpPage(),
        //home: MapsIp(),
        //  home: const LoginPage(),
      ),
    );
  }
}
