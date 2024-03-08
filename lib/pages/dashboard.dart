import 'package:mip_app/controllers/homeController.dart';
import 'package:mip_app/pages/chamados/create-defeito-page.dart';
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

  onBarItemClicked(int i) {
    setState(() {
      conHome.indexSelected.value = i;
      controller!.index = conHome.indexSelected.value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 4, vsync: this);
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
          CreateDefeitoPage(),
          TripsPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card), label: "Earnings"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_tree), label: "Trips"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
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
