
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mip_app/controllers/itemController.dart';
import 'package:mip_app/controllers/ordemController.dart';
import 'package:mip_app/global/app_colors.dart';
import 'package:mip_app/global/app_text_styles.dart';
import 'package:mip_app/global/util.dart';
import 'package:mip_app/pages/ordem/widget/cabecalho_create_ordem.dart';
import 'package:mip_app/pages/ordem/widget/lista_itens.dart';

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

  iniciar() async {
    ordem = '${DateFormat("yyMMdd").format(DateTime.now())}$tipo';
    await conOrd.getOrdemByFinalizada(ordem);
    conIte.getItensByTipo(tipo);
  //  conIte.updateItens( context, ordem);
  }

  @override
  void initState() {
    super.initState();
    iniciar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 100,
        color: AppColors.primaria,
        width: MediaQuery.of(context).size.width,
        child: Center(
            child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Total da Ordem R\$ ${formatador.format(conIte.totalOrdem.value)}",
                style: AppTextStyles.heading15.copyWith(fontSize: 20),
              ),
               InkWell(
                      onTap: () async {
                        Map<String, Object> ord = {
                          "ano": DateFormat("yyyy").format(DateTime.now()),
                          "mes": DateFormat("MM").format(DateTime.now()),
                          "id": ordem.toString(),
                          "cod": ordem,
                          "tipo": tipo,
                          "valor": conIte.totalOrdem.value,
                          "isFinalizada": false,
                          "isConfirmada": false,
                          "isAberta": "${tipo}.1",
                          "createdAt": DateTime.now().toString(),
                          "modifiedAt": DateTime.now().toString(),
                          "isAtivo": true,
                          "itensOrdem": conIte.listaFiltrada,
                          "status": StatusApp.ordemGerada.message,
                          "urlSf": "",
                          "urlNf": ""
                        };

                        await conOrd.createdOrdem(ord, context, ordem);

                        for (var x in conIte.listaItens) {
                          conIte.alteraOrdem(x['id'],ordem);
                        }
                      },
                      child: Text(
                        "Gerar Ordem de Itens",
                        style: AppTextStyles.heading,
                      ),
                    )

            ],
          ),
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
                          //   DateTime crea = DateTime.parse(item['modifiedAt']);

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
