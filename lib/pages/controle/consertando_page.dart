import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/chamadoController.dart';
import 'package:mip_app/controllers/controleController.dart';
import 'package:mip_app/controllers/itemController.dart';
import 'package:mip_app/global/app_colors.dart';
import 'package:mip_app/global/app_text_styles.dart';
import 'package:mip_app/global/util.dart';
import 'package:mip_app/widgets/listaItensLicitados.dart';
import 'package:mip_app/widgets/listaItensServicosUtilizados.dart';

class ConsertandoPage extends StatefulWidget {
  dynamic chamado;

  ConsertandoPage(this.chamado, {Key? key}) : super(key: key);

  @override
  State<ConsertandoPage> createState() => _ConsertandoPageState();
}

class _ConsertandoPageState extends State<ConsertandoPage> {
  final ControleController conCon = Get.put(ControleController());
  final ItemController conIte = Get.put(ItemController());
  final ChamadoController conCha = Get.put(ChamadoController());

  alteraSTatus() async {
    await conCha.alterarStatusChamado(context, widget.chamado['id'], widget.chamado['idIp'],
        StatusApp.concertando.message);
  }

  @override
  void initState() {
    alteraSTatus();
    conCon.getItens();
    conCon.getItensUtilizados(widget.chamado['id'].toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consertar Luminária ${widget.chamado['idIp']}"),
      ),
      body: _body(context),
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.amber,
        child: InkWell(
            onTap: () {
              conCha.finalizarConcerto(
                  context, StatusApp.concertado.message, widget.chamado);
            },
            child: Center(
                child: Text(
              "Finalizar Concerto.",
              style: AppTextStyles.body20,
            ))),
      ),
    );
  }

  _body(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 100,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: conCon.index.value == 0
                                ? AppColors.borderCards
                                : AppColors.borderCardsOff,
                            width: 2)),
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            conCon.index(0);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text('Itens'),
                        )),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: conCon.index.value == 1
                              ? AppColors.borderCards
                              : AppColors.borderCardsOff,
                          width: 2)),
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          conCon.index(1);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text('Serviços'),
                      )),
                ),
              ],
            ),
          ),
          conCon.index == 0
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColors.primaria, width: 2)),
                    child: ListView.builder(
                        itemCount: conCon.listaItens.length,
                        itemBuilder: (context, index) {
                          var item = conCon.listaItens[index];
                          final nome = item['nome'].toString();

                          return ListaItensLicitados(
                              item, nome, 1, widget.chamado);
                        }),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.amber, width: 2)),
                    child: ListView.builder(
                        itemCount: conCon.listaServicos.length,
                        itemBuilder: (context, index) {
                          var item = conCon.listaServicos[index];
                          final nome = item['nome'].toString();
                          return ListaItensLicitados(
                              item, nome, 2, widget.chamado);
                        }),
                  ),
                ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.amber, width: 2)),
                  padding: EdgeInsets.all(5),
                  child: ListaItensServicosUtilizados(widget.chamado['id'])),
            ),
          )
        ],
      ),
    );
  }
}
