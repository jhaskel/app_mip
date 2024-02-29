import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/controleController.dart';
import 'package:mip_app/controllers/itemController.dart';
import 'package:mip_app/global/app_text_styles.dart';
import 'package:mip_app/global/util.dart';
import 'package:mip_app/widgets/listaItensLicitados.dart';
import 'package:mip_app/widgets/listaItensServicosUtilizados.dart';

class FinalizandoPage extends StatefulWidget {
  dynamic chamado;

  FinalizandoPage(this.chamado, {Key? key}) : super(key: key);

  @override
  State<FinalizandoPage> createState() => _FinalizandoPageState();
}

class _FinalizandoPageState extends State<FinalizandoPage> {
  final ControleController conCon = Get.put(ControleController());
  final ItemController conIte = Get.put(ItemController());

  @override
  void initState() {
    super.initState();
    conCon.getItens();
    conCon.getItensUtilizados(widget.chamado['id'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Finalizando Consertos ${widget.chamado['idIp']}",
        ),
      ),
      body: _body(context),
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.amber,
        child: InkWell(
            onTap: () {
              conIte.createItem(
                  context, conCon.listaFinal, StatusApp.lancado.message);
              //   conCon.index(0);
            },
            child: Center(
                child: Text(
              "Finalizar Lançamento",
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
            height: 50,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: conCon.index.value == 0
                                ? Colors.amber
                                : Colors.black26,
                            width: 2)),
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            conCon.index(0);
                          });
                        },
                        child: Text('Itens')),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: conCon.index.value == 1
                              ? Colors.amber
                              : Colors.black26,
                          width: 2)),
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          conCon.index(1);
                        });
                      },
                      child: Text('Serviços')),
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
                        border: Border.all(color: Colors.amber, width: 2)),
                    child: ListView.builder(
                        itemCount: conCon.listaItens.length,
                        itemBuilder: (context, index) {
                          var item = conCon.listaItens[index];
                          final nome = item['nome'].toString();

                          ListaItensLicitados(item, nome, 1, widget.chamado);
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

                          ListaItensLicitados(item, nome, 2, widget.chamado);
                        }),
                  ),
                ),
          Container(
            height: 30,
            child: Center(
              child: Text(
                'ITENS E SERVIÇOS UTILIZADOS - (${conCon.listaFinal.length}) itens',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber, width: 2)),
                padding: EdgeInsets.all(5),
                child: ListaItensServicosUtilizados(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
