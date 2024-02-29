import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/ipController.dart';

class IpPage extends StatefulWidget {
  const IpPage({super.key});

  @override
  State<IpPage> createState() => _IpPageState();
}

class _IpPageState extends State<IpPage> {
  final IpController conIp = Get.put(IpController());
  @override
  void initState() {
    super.initState();
    conIp.getIp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("IpPage")),
      body: _body(context),
      bottomNavigationBar: Container(
        height: 100,
        color: Colors.amber,
        child: Center(
          child: Text("Novo Ip"),
        ),
      ),
    );
  }

  _body(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          color: Colors.amber,
        ),
        Expanded(
          child: Container(
              child: Obx(
            () => ListView.builder(
                itemCount: conIp.listaIp.length,
                itemBuilder: (context, index) {
                  var item = conIp.listaIp[index];

                  return Text(item['cod']);
                }),
          )),
        ),
      ],
    );
  }
}
