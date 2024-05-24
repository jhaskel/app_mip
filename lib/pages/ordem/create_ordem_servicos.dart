import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:mip_app/controllers/itemController.dart';
import 'package:mip_app/controllers/ordemController.dart';
import 'package:mip_app/global/app_text_styles.dart';
import 'package:mip_app/global/util.dart';
import 'package:mip_app/pages/ordem/widget/cabecalho_create_ordem.dart';
import 'package:mip_app/pages/ordem/widget/lista_itens.dart';

class CreateOrdemServicos extends StatefulWidget {
  const CreateOrdemServicos({Key? key}) : super(key: key);

  @override
  State<CreateOrdemServicos> createState() => _CreateOrdemServicosState();
}

class _CreateOrdemServicosState extends State<CreateOrdemServicos> {
  final ItemController conIte = Get.put(ItemController());
  final OrdemController conOrd = Get.put(OrdemController());
  var formatador = NumberFormat("#,##0.00", "pt_BR");

  String ordem = "";
  String tipo = "2";

  @override
  void initState() {
    super.initState();
    conIte.getItensByTipo(tipo);
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
                  "tipo":tipo,
                  "isFinalizada": false,
                  "isConfirmada": false,
                  "createdAt": DateTime.now().toString(),
                  "modifiedAt": DateTime.now().toString(),
                  "isAtivo": true,
                  "itensOrdem": conIte.listaFiltrada,
                  "status": StatusApp.ordemGerada.message,
                  "urlSf":"",
                  "urlNf":""
                };

                await conOrd.createdOrdem(ord, context, ordem);

                for (var x in conIte.listaItens) {
                  conIte.alteraOrdem(x['id'], ordem);
                }
              },
              child: Text(
                "Gerar Ordem de Serviços",
                style: AppTextStyles.heading,
              ),
            ),
          ],
        )),
      ),
      body: Obx(
        () => Column(
          children: [
            cabecalhoCreateOrdem(),
            Expanded(
              child: Container(
                child: conIte.listaFiltrada.length > 0
                    ? ListView.builder(
                        itemCount: conIte.listaFiltrada.length,
                        itemBuilder: (context, index) {
                          var item = conIte.listaFiltrada[index];

                          var ip = item['cod'];
                          var nome = item['nome'];
                          var unidade = item['unidade'];
                          var quantidade = item['quant'];
                          var valor = item['valor'];
                          var total = item['total'];

                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListaItens(ip, unidade, nome, quantidade,
                                    valor, total),
                              ),
                              Divider(
                                thickness: 1,
                              )
                            ],
                          );
                        })
                    : Center(
                        child: Text("Nenhum item encontrado!"),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
