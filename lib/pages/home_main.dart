import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mip_app/controllers/homeMainController.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  double fd = 0.0;
  String fds = '0m';
  final controller = Get.put(HomeMainController());

  String controla(double valor) {
    if (valor < 1) {
      return fds = '${(valor * 1000).toStringAsFixed(0)} m';
    } else {
      return '${(valor).toStringAsFixed(0)} km';
    }
  }

  filtro() {
    return Slider(
      value: fd,
      min: 0,
      max: 10,
      divisions: 10000,
      label: controla(fd),
      onChanged: (value) {
        setState(() {
          fd = value;
        });
        print("fd $fd");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeMainController());
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Container(
              width: 200,
              child: filtro(),
            ),
          ),
        ],
      ),
    );
  }
}
