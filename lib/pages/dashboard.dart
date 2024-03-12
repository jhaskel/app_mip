import 'package:mip_app/controllers/homeController.dart';
import 'package:mip_app/controllers/usuarioController.dart';
import 'package:mip_app/pages/cadastro/cadastro_page.dart';

import 'package:mip_app/pages/chamados/create-defeito-page.dart';
import 'package:mip_app/pages/controle/controle_page.dart';
import 'package:mip_app/pages/maps/MapsChamadoPage.dart';
import 'package:mip_app/pages/profile_page.dart';
import 'package:mip_app/pages/trips_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  HomeController conHome = Get.put(HomeController());
  UsuarioController conUse = Get.put(UsuarioController());

  onBarItemClicked(int i) {
    setState(() {
      conHome.indexSelected.value = i;
      controller!.index = conHome.indexSelected.value;
    });
  }
  List <String>telas = ["Home","Controle","Chamado","Profile","Cadastros"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    conUse.userCurrent(context);
    controller = TabController(length: telas.length, vsync: this);
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          MapsChamadoPage(),
          ControlePage(),
          CreateDefeitoPage(),
          ProfilePage(),
          CadastroPage(),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:  [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: telas[0]),
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card), label: telas[1]),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_sharp,color: Colors.amber,size: 30,), label: telas[2]),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: telas[3]),
          BottomNavigationBarItem(icon: Icon(Icons.g_mobiledata), label: telas[4]),

        ],
        currentIndex: conHome.indexSelected.value,
        //backgroundColor: Colors.grey,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.pink,
        showSelectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        onTap: onBarItemClicked,
      ),
    );
  }
}
