import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:mip_app/controllers/itemController.dart';
import 'package:mip_app/controllers/ordemController.dart';
import 'package:mip_app/global/app_text_styles.dart';
import 'package:mip_app/global/util.dart';
import 'package:mip_app/pages/controle/finalizando_page.dart';

class CreateOrdemItens extends StatefulWidget {
  const CreateOrdemItens({Key? key}) : super(key: key);

  @override
  State<CreateOrdemItens> createState() => _CreateOrdemItensState();
}

class _CreateOrdemItensState extends State<CreateOrdemItens> {
  final ItemController conIte = Get.put(ItemController());
  final OrdemController conOrd = Get.put(OrdemController());
  var formatador = NumberFormat("#,##0.00", "pt_BR");

  String ordem = "";
  String tipo = "1";

  @override
  void initState() {
    super.initState();
    conIte.getItens(tipo);
    ordem = '${DateFormat("yyMMdd").format(DateTime.now())}$tipo';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 100,
        color: Colors.amber,
        width: MediaQuery.of(context).size.width,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
                  "Total da Ordem R\$ ${formatador.format(conIte.totalOrdem.value)}",
                  style: AppTextStyles.heading15.copyWith(fontSize: 20),
                )),
            InkWell(
              onTap: () async {
                var ord = {
                  "ano": DateFormat("yyyy").format(DateTime.now()),
                  "mes": DateFormat("MM").format(DateTime.now()),
                  "id": ordem.toString(),
                  "cod": ordem,
                  "valor": conIte.totalOrdem.value,
                  "isFinalizada": false,
                  "createdAt": DateTime.now().toString(),
                  "modifiedAt": DateTime.now().toString(),
                  "isAtivo": true,
                  "itensOrdem": conIte.listaFiltrada,
                  "status": StatusApp.ordemGerada.message
                };

                await conOrd.createdOrdem(ord, context, ordem);

                for (var x in conIte.listaItens) {
                  conIte.alteraOrdem(x['id'], ordem);
                }
              },
              child: Text(
                "Gerar Ordem de Itens",
                style: AppTextStyles.heading,
              ),
            ),
          ],
        )),
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
                  Flexible(flex: 1, fit: FlexFit.tight, child: Text("cod")),
                  Flexible(flex: 1, fit: FlexFit.tight, child: Text("unidade")),
                  Flexible(flex: 4, fit: FlexFit.tight, child: Text("Nome")),
                  Flexible(
                      flex: 1, fit: FlexFit.tight, child: Text("quantidade")),
                  Flexible(flex: 1, fit: FlexFit.tight, child: Text("valor")),
                  Flexible(flex: 1, fit: FlexFit.tight, child: Text("total")),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: conIte.listaFiltrada.length > 0
                    ? ListView.builder(
                        itemCount: conIte.listaFiltrada.length,
                        itemBuilder: (context, index) {
                          var item = conIte.listaFiltrada[index];
                          //   DateTime crea = DateTime.parse(item['modifiedAt']);

                          var ip = item['cod'];

                          var nome = item['nome'];

                          var unidade = item['unidade'];

                          var quantidade = item['quant'];

                          var valor = item['valor'];

                          var total = item['total'];

                          return Row(
                            children: [
                              Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Text(ip == null ? "" : ip.toString())),
                              Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Text(unidade)),
                              Flexible(
                                  flex: 4,
                                  fit: FlexFit.tight,
                                  child: Text(nome)),
                              Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Text(quantidade.toString())),
                              Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child:
                                      Text('R\$ ${formatador.format(valor)}')),
                              Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child:
                                      Text('R\$ ${formatador.format(total)}')),
                            ],
                          );
                        })
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
