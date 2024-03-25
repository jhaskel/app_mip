import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mip_app/controllers/spashController.dart';
import 'package:mip_app/controllers/usuarioController.dart';
import 'package:mip_app/global/global_var.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  SplashServices splashScreen = SplashServices();

  final UsuarioController conUse= Get.put(UsuarioController());
  init()async{
    await  conUse.userCurrent(context);
    splashScreen.isLogin(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   init();

  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Manutenção Iluminação Pública' , style: TextStyle(fontSize: 30),),
      ),
    );
  }
}
