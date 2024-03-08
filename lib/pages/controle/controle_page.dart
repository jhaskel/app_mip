import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/chamadoController.dart';

import 'package:intl/intl.dart';
import 'package:mip_app/global/app_colors.dart';
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
    conCha.getChamadosConcertado(context, "realizado");
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
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          width: 2, color: AppColors.borderCabecalho),
                      bottom: BorderSide(
                          width: 2, color: AppColors.borderCabecalho))),
              height: conCha.alturaContainer.value,
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
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                child: conCha.listaChamados.length > 0
                    ? ListView.separated(
                        itemCount: conCha.listaChamados.length,
                        itemBuilder: (context, index) {
                          var item = conCha.listaChamados[index];
                          DateTime crea = DateTime.parse(item['modifiedAt']);

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FinalizandoPage(item)),
                              );
                            },
                            child: Row(
                              children: [
                                Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child:
                                        Text(DateFormat("dd/MM").format(crea))),
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
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            thickness: 1,
                          );
                        },
                      )
                    : Center(
                        child: Text("Nenhum Ip"),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
