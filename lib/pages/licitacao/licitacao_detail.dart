import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mip_app/controllers/chamadoController.dart';
import 'package:mip_app/controllers/ipController.dart';
import 'package:mip_app/controllers/itemController.dart';
import 'package:mip_app/controllers/licitacaoController.dart';
import 'package:mip_app/global/app_text_styles.dart';
import 'package:mip_app/pages/chamados/chamado_page_detail.dart';

import '../../global/app_colors.dart';

class LicitacaoDetail extends StatefulWidget {
  dynamic item;
  LicitacaoDetail(this.item, {super.key});

  @override
  State<LicitacaoDetail> createState() => _LicitacaoDetailState();
}

class _LicitacaoDetailState extends State<LicitacaoDetail> {
  get item => widget.item;
  final ChamadoController conCha = Get.put(ChamadoController());
  final LicitacaoController conLicitacao = Get.put(LicitacaoController());
  final ItemController conIte = Get.put(ItemController());
  double alturaContainer = 120;
  int chamadosTotal = 0;
  int chamadosAbertos = 0;
  int chamadosRealizados = 0;
  double gastoTotal = 0.0;
  double larguraContainer = 0.0;

  Padding demonstrativoLicitacao(String valor, String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: alturaContainer,
        width: larguraContainer,
        decoration:
            BoxDecoration(border: Border.all(width: 2, color: Colors.amber)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            valor,
            style: AppTextStyles.heading40White.copyWith(fontSize: 30),
          ),
          Text(title),
        ]),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    print('licitacao $item');
    larguraContainer = (MediaQuery.of(context).size.width / 4) - 20;
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text("${conLicitacao.textPage.value} ${item['processo']}"),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: Icon(Icons.refresh))
          ],
        ),
        body: _body(),
      ),
    );
  }

  _body() {
    return StreamBuilder(
      stream: conCha.ref.orderByChild('idLicitacao').equalTo(item['id']).onValue,
      builder: (context, snapshott) {
        if (!snapshott.hasData) {
          return CircularProgressIndicator();
        } else {
          if (snapshott.data!.snapshot.value == null) {
            return Center(
                child: Container(
              child: Text("Nenhum Chamado Para esse IP"),
            ));
          } else {
            chamadosTotal = 0;
            chamadosAbertos = 0;
            chamadosRealizados = 0;
            gastoTotal = 0.0;
            Map<dynamic, dynamic> maps = snapshott.data!.snapshot.value as Map;
            List<dynamic> list = [];

            list.clear();
            list = maps.values.toList();

            list = maps.values.toList()
              ..sort(((a, b) => (b["createdAt"]).compareTo((a["createdAt"]))));
            chamadosTotal = list.length;

            for (var x in list) {
              if (x['isChamado'] == true) {
                chamadosAbertos++;
              } else {
                print("tot ${x['total']}");
                gastoTotal = gastoTotal + x['total'];
              }
            }

            chamadosRealizados = chamadosTotal - chamadosAbertos;

            return Column(
              children: [
                Container(
                  height: 200,
                  child: Row(children: [
                    demonstrativoLicitacao(
                        chamadosTotal.toString(), 'total de chamados'),
                    demonstrativoLicitacao(
                        chamadosAbertos.toString(), 'Chamados Abertos'),
                    demonstrativoLicitacao(
                        chamadosRealizados.toString(), 'Chamados Realizados'),
                    demonstrativoLicitacao(gastoTotal.toString(), 'Gasto total'),
                  ]),
                ),
                Obx(() => Container(
                      height: conCha.alturaContainer.value,
                      width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              width: 2, color: AppColors.borderCabecalho),
                          bottom: BorderSide(
                              width: 2, color: AppColors.borderCabecalho))),
                      child: Row(children: [
                        Container(
                          width: 300,
                          child: Text('cod'),
                        ),
                        Container(
                          width: 100,
                          child: Text("criado em"),
                        ),
                        Container(
                          width: 100,
                          child: Text("alterado em"),
                        ),
                        Container(
                          width: 100,
                          child: Text("Defeito"),
                        ),
                        Container(
                          width: 100,
                          child: Text("Gasto"),
                        ),
                        Spacer(),
                        Container(
                          width: 100,
                          child: Text("Status"),
                        ),
                      ]),
                    )),
                Expanded(
                  child: ListView.separated(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      var item = list[index];
                      DateTime dtCrea = DateTime.parse(item['createdAt']);
                      DateTime dtAlt = DateTime.parse(item['modifiedAt']);

                      var total = 0.0;
                      if (item['total'] > 0.0) {
                        total = item['total'];
                      }

                      return InkWell(
                        onTap: (){

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChamadoPageDetail(item)),
                          );
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Row(children: [
                              Container(
                                width: 300,
                                child: Text(item['id']),
                              ),
                              Container(
                                width: 100,
                                child: Text(DateFormat("dd/MM").format(dtCrea)),
                              ),
                              Container(
                                width: 100,
                                child: Text(DateFormat("dd/MM").format(dtAlt)),
                              ),
                              Container(
                                width: 100,
                                child: Text(item['defeito']),
                              ),
                              Container(
                                width: 100,
                                child: Text(total.toString()),
                              ),
                              Spacer(),
                              Container(
                                width: 100,
                                child: item['isChamado']
                                    ? Icon(
                                        Icons.circle,
                                        color: Colors.blue,
                                      )
                                    : Icon(
                                        Icons.circle,
                                        color: Colors.green,
                                      ),
                              ),
                            ])),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        thickness: 1,
                      );
                    },
                  ),
                ),
              ],
            );
          }
        }
      },
    );
  }
}
