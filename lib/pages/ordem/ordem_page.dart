import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:mip_app/controllers/itemController.dart';
import 'package:mip_app/controllers/ordemController.dart';
import 'package:mip_app/global/app_colors.dart';
import 'package:mip_app/pages/ordem/ordem_details.dart';

class OrdemPage extends StatefulWidget {
  const OrdemPage({Key? key}) : super(key: key);

  @override
  State<OrdemPage> createState() => _OrdemPageState();
}

class _OrdemPageState extends State<OrdemPage> {
  final ItemController conIte = Get.put(ItemController());
  final OrdemController conOrd = Get.put(OrdemController());
  var formatador = NumberFormat("#,##0.00", "pt_BR");

  String ordem = "";
  String tipo = "1";

  @override
  void initState() {
    super.initState();
    conOrd.getOrdem();
    ordem = '${DateFormat("yyMMdd").format(DateTime.now())}$tipo';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(conOrd.nomePage.value),
        ),
        body: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          width: 2, color: AppColors.borderCabecalho),
                      bottom: BorderSide(
                          width: 2, color: AppColors.borderCabecalho))),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Flexible(flex: 1, fit: FlexFit.tight, child: Text("data")),
                  Flexible(flex: 1, fit: FlexFit.tight, child: Text("cod")),
                  Flexible(flex: 4, fit: FlexFit.tight, child: Text("status")),
                  Flexible(flex: 1, fit: FlexFit.tight, child: Text("valor")),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                child: conOrd.listaOrdens.length > 0
                    ? ListView.separated(
                        itemCount: conOrd.listaOrdens.length,
                        itemBuilder: (context, index) {
                          dynamic item = conOrd.listaOrdens[index];
                          DateTime crea = DateTime.parse(item['modifiedAt']);

                          var cod = item['cod'];

                          var status = item['status'];

                          var valor = item['valor'];

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrdemDetails(
                                        conOrd.listaOrdens[index])),
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
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Text(cod)),
                                Flexible(
                                    flex: 4,
                                    fit: FlexFit.tight,
                                    child: Text(status)),
                                Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Text(
                                        'R\$ ${formatador.format(valor)}')),
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
                        child: Text("Nenhuma Ordem Encontrada"),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
