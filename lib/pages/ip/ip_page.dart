import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/ipController.dart';
import 'package:mip_app/pages/ip/ip_detail.dart';

class IpPage extends StatefulWidget {
  const IpPage({super.key});

  @override
  State<IpPage> createState() => _IpPageState();
}

class _IpPageState extends State<IpPage> {
  final IpController conIp = Get.put(IpController());
  double alturaContainer = 120;
  double larguraContainer = 120;
  @override
  void initState() {
    super.initState();

    conIp.getIp();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(title: Text(conIp.textPage.value)),
        bottomNavigationBar: Container(
          height: 100,
          color: Colors.amber,
          child: Center(
            child: Text("Novo Ip"),
          ),
        ),
        body: Column(
          children: [
            Container(
              height: 200,
              child: Row(children: [
                demonstrativoIp(conIp.quantIp.value.toString(), 'total de ip'),
                demonstrativoIp(
                    conIp.quantIpNormal.value.toString(), 'Ip Normal'),
                demonstrativoIp(
                    conIp.quantIpDefeito.value.toString(), 'Ip Defeito'),
                demonstrativoIp(
                    conIp.quantIpAgendado.value.toString(), 'Ip Agendado'),
              ]),
            ),
            Expanded(
              child: conIp.listaIp.length > 0
                  ? Container(
                      child: ListView.builder(
                          itemCount: conIp.listaIp.length,
                          itemBuilder: (context, index) {
                            var item = conIp.listaIp[index];

                            return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => IpDetail(item)),
                                  );
                                },
                                child: Text(item['cod']));
                          }),
                    )
                  : Container(
                      child: Center(
                      child: Text("Não foram encontrados nenhum Ip"),
                    )),
            ),
          ],
        ),
      ),
    );
  }

  Padding demonstrativoIp(String valor, String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: alturaContainer,
        width: larguraContainer,
        decoration:
            BoxDecoration(border: Border.all(width: 2, color: Colors.amber)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(valor),
          Text(title),
        ]),
      ),
    );
  }
}
