import 'package:mip_app/controllers/homeController.dart';
import 'package:mip_app/controllers/usuarioController.dart';
import 'package:mip_app/pages/cadastro/cadastro_supervisor_page.dart';
import 'package:mip_app/pages/chamados/create-defeito-page.dart';
import 'package:mip_app/pages/controle/controle_page.dart';
import 'package:mip_app/pages/maps/MapsChamadoPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/pages/profile/profile_page.dart';

class DashboardSupervisor extends StatefulWidget {
  DashboardSupervisor({super.key});

  @override
  State<DashboardSupervisor> createState() => _DashboardSupervisorState();
}

class _DashboardSupervisorState extends State<DashboardSupervisor>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  HomeController conHome = Get.put(HomeController());
  UsuarioController conUse = Get.put(UsuarioController());
  int indexSelected=0;

  onBarItemClicked(int i) {
    setState(() {
      indexSelected = i;
      controller!.index = indexSelected;
    });
  }
  List <String>telas = ["Home","Controle","Chamado","Cadastro","Profile"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    conUse.userCurrent(context);
    controller = TabController(length: 5, vsync: this);
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
          CadastroSupervisorPage(),
          ProfilePage(),
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
        currentIndex: indexSelected,
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