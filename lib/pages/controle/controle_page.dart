import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/chamadoController.dart';

import 'package:intl/intl.dart';
import 'package:mip_app/pages/controle/finalizando_page.dart';

class ControlePage extends StatefulWidget {
  const ControlePage({Key? key}) : super(key: key);

  @override
  State<ControlePage> createState() => _ControlePageState();
}

class _ControlePageState extends State<ControlePage> {
  final ChamadoController conCha = Get.put(ChamadoController());

  @override
  void initState() {
    super.initState();
    conCha.getChamadosConcertado(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Controle'),
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
                  Flexible(flex: 2, fit: FlexFit.tight, child: Text("Defeito")),
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
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  FinalizandoPage(item)),
                                );

                              },
                              child: Row(
                                children: [
                                  Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: Text(DateFormat("dd/MM").format(crea))),
                                  Flexible(
                                      flex: 2,
                                      fit: FlexFit.tight,
                                      child: Text(item['defeito'])),
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
