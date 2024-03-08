import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mip_app/controllers/chamadoController.dart';
import 'package:mip_app/controllers/itemController.dart';
import 'package:mip_app/global/app_colors.dart';
import 'package:mip_app/global/app_text_styles.dart';
import 'package:mip_app/global/util.dart';

class ChamadoDetails extends StatefulWidget {
  dynamic chamado;
  ChamadoDetails(this.chamado, {super.key});

  @override
  State<ChamadoDetails> createState() => _ChamadoDetailsState();
}

class _ChamadoDetailsState extends State<ChamadoDetails> {
  final ChamadoController conCha = Get.put(ChamadoController());
  final ItemController conIte = Get.put(ItemController());

  get chamado => widget.chamado;
  var formatador = NumberFormat("#,##0.00", "pt_BR");

  @override
  void initState() {
    super.initState();

    conIte.getItensByChamado(chamado['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhe do chamado ${chamado['id']}')),
      body: _body(context),
      bottomNavigationBar: Container(
        height: 100,
        color: AppColors.primaria,
        width: MediaQuery.of(context).size.width,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
                  "Total do Chamado R\$ ${formatador.format(conIte.totalChamado.value)}",
                  style: AppTextStyles.heading15.copyWith(fontSize: 20),
                )),
            InkWell(
              onTap: () async {
                Get.defaultDialog(
                  title: ("Autorizar Conserto"),
                  content: Text(
                      'Tem certeza que deseja autorizar o concerto no Ip ${chamado['idIp']}'),
                  onCancel: () {},
                  onConfirm: () {
                    conCha.alterarStatus(
                        chamado['id'],
                        chamado['idIp'],
                        StatusApp.autorizado.message,
                        conIte.totalChamado.value);
                    Get.back();
                    Navigator.pop(context);
                  },
                );
              },
              child: Text(
                "Autorizar Chamado",
                style: AppTextStyles.heading,
              ),
            ),
          ],
        )),
      ),
    );
  }

  _body(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              child: Text('${conIte.textDetail.value} ${chamado['idIp']}'),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: ListView.builder(
                    itemCount: conIte.listaItensChamado.length,
                    itemBuilder: (context, index) {
                      var item = conIte.listaItensChamado[index];

                      var nome = item['nome'];
                      var unidade = item['unidade'];
                      var quant = item['quant'];
                      var valor = item['valor'];
                      var total = item['valor'] * quant;

                      int caracteres = nome.length;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              caracteres > 40
                                  ? Container(
                                      child: Text(
                                      nome,
                                      overflow: TextOverflow.ellipsis,
                                    ))
                                  : Container(
                                      child: Text(
                                      nome,
                                    )),
                              Spacer(),
                              Container(width: 50, child: Text(unidade)),
                              Container(
                                  width: 25,
                                  child: Center(child: Text(quant.toString()))),
                              Container(
                                  width: 50,
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child:
                                          Text('${formatador.format(valor)}'))),
                              Container(
                                  width: 50,
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child:
                                          Text('${formatador.format(total)}'))),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                          )
                        ],
                      );
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
