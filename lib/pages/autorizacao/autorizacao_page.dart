import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/chamadoController.dart';

import 'package:intl/intl.dart';
import 'package:mip_app/controllers/ipController.dart';
import 'package:mip_app/global/util.dart';
import 'package:mip_app/pages/controle/finalizando_page.dart';

class AutorizacaoPage extends StatefulWidget {
  const AutorizacaoPage({Key? key}) : super(key: key);

  @override
  State<AutorizacaoPage> createState() => _AutorizacaoPageState();
}

class _AutorizacaoPageState extends State<AutorizacaoPage> {
  final AutorizacaoPage conAut = Get.put(AutorizacaoPage());
  final ChamadoController conCha = Get.put(ChamadoController());
  final IpController conIp = Get.put(IpController());

  @override
  void initState() {
    super.initState();
    conCha.getChamadosConcertado(context, "lancado");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Autorizacao'),
      ),
      body: Obx(
        () => Column(
          children: [
            Container(
              height: 50,
              color: Colors.grey,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Flexible(flex: 1, fit: FlexFit.tight, child: Text("Data")),
                  Flexible(flex: 2, fit: FlexFit.tight, child: Text("Chamado")),
                  Flexible(flex: 1, fit: FlexFit.tight, child: Text("Ip")),
                  Flexible(flex: 2, fit: FlexFit.tight, child: Text("Status")),
                ],
              ),
            ),
            Expanded(
              child: Container(
                height: 400,
                child: Center(
                  child: conCha.listaChamados.length > 0
                      ? ListView.builder(
                          itemCount: conCha.listaChamados.length,
                          itemBuilder: (context, index) {
                            var item = conCha.listaChamados[index];
                            DateTime crea = DateTime.parse(item['modifiedAt']);

                            return InkWell(
                              onTap: () {
                                Get.defaultDialog(
                                  title: ("Autorizar Conserto"),
                                  content: Text(
                                      'Tem certeza que deseja autorizar o concerto no Ip ${item['idIp']}'),
                                  onCancel: () {},
                                  onConfirm: () {
                                    print(item['tipo']);
                                    conCha.alterarStatus(
                                        item['id'],
                                        item['idIp'],
                                        StatusApp.autorizado.message);
                                    Get.back();
                                  },
                                );
                              },
                              child: Row(
                                children: [
                                  Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: Text(
                                          DateFormat("dd/MM").format(crea))),
                                  Flexible(
                                      flex: 2,
                                      fit: FlexFit.tight,
                                      child: Text(item['id'])),
                                  Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: Text(item['idIp'])),
                                  Flexible(
                                      flex: 2,
                                      fit: FlexFit.tight,
                                      child: Text(item['status'])),
                                ],
                              ),
                            );
                          })
                      : Center(
                          child: Text("Nenhum Ip"),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
