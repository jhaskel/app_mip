import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mip_app/controllers/chamadoController.dart';
import 'package:mip_app/controllers/ipController.dart';
import 'package:mip_app/controllers/itemController.dart';
import 'package:mip_app/global/app_colors.dart';
import 'package:mip_app/global/app_text_styles.dart';

class ChamadoPageDetail extends StatefulWidget {
  dynamic item;
  ChamadoPageDetail(this.item, {super.key});

  @override
  State<ChamadoPageDetail> createState() => _ChamadoPageDetailState();
}

class _ChamadoPageDetailState extends State<ChamadoPageDetail> {
  get item => widget.item;
  final ChamadoController conCha = Get.put(ChamadoController());
  final IpController conIp = Get.put(IpController());
  final ItemController conIte = Get.put(ItemController());
  double alturaContainer = 120;

  int itensChamado = 0;
  int chamadosAbertos = 0;
  int chamadosRealizados = 0;
  double gastoTotal = 0.0;
  double larguraContainer = 0.0;

  Padding demonstrativoIp(String valor, String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: alturaContainer,
        width: larguraContainer,
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: AppColors.primaria)),
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
    larguraContainer = (MediaQuery.of(context).size.width / 3) - 20;
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text("${conCha.textPage.value} ${item['id']}"),
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
      stream: conIte.ref.orderByChild('chamado').equalTo(item['id']).onValue,
      builder: (context, snapshott) {
        if (!snapshott.hasData) {
          return CircularProgressIndicator();
        } else {
          if (snapshott.data!.snapshot.value == null) {
            return Center(
                child: Container(
              child: Text("Nenhum Item para esse chamado"),
            ));
          } else {
            itensChamado = 0;
            chamadosAbertos = 0;
            chamadosRealizados = 0;
            gastoTotal = 0.0;
            Map<dynamic, dynamic> maps = snapshott.data!.snapshot.value as Map;
            List<dynamic> list = [];

            list.clear();
            list = maps.values.toList();

            list = maps.values.toList()
              ..sort(((a, b) => (b["createdAt"]).compareTo((a["createdAt"]))));
            itensChamado = list.length;

            for (var x in list) {
              print("tot ${x['total']}");
              gastoTotal = gastoTotal + x['total'];
            }

            chamadosRealizados = itensChamado - chamadosAbertos;

            return Column(
              children: [
                Container(
                  height: 200,
                  child: Row(children: [
                    demonstrativoIp(item['idIp'], 'IP'),
                    demonstrativoIp(itensChamado.toString(), 'total de itens'),
                    demonstrativoIp(gastoTotal.toString(), 'Gasto total'),
                  ]),
                ),
                Container(
                  height: conCha.alturaContainer.value,

                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              width: 2, color: AppColors.borderCabecalho),
                          bottom: BorderSide(
                              width: 2, color: AppColors.borderCabecalho))),
                  width: MediaQuery.of(context).size.width,
                  child: Row(children: [
                    Container(
                      width: 100,

                      child: Text("data"),
                    ),
                    Container(
                      width: 100,
                      child: Text("operador"),
                    ),
                    Container(
                      width: 100,
                      child: Text("unidade"),
                    ),
                    Container(
                      child: Text("item"),
                    ),
                    Spacer(),
                    Container(
                      width: 100,
                      child: Text("quant"),
                    ),
                    Container(
                      width: 100,
                      child: Text("valor"),
                    ),
                    Container(
                      width: 100,
                      child: Text("ordem"),
                    )
                  ]),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      var item = list[index];
                      DateTime dtCrea = DateTime.parse(item['createdAt']);

                      var total = item['total'];
                      int caractere= item['ordem'].length;

                      return Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(children: [
                            Container(
                              width: 100,
                              child: Text(DateFormat("dd/MM").format(dtCrea)),
                            ),
                            Container(
                              width: 100,
                              child: Text(item['user'] ?? "",overflow: TextOverflow.ellipsis,),
                            ),
                            Container(
                              width: 100,
                              child: Text(item['unidade']),
                            ),
                            Container(
                              child: Text(item['nome']),
                            ),
                            Spacer(),
                            Container(
                              width: 100,
                              child: Text(item['quant'].toString()),
                            ),
                            Container(
                              width: 100,
                              child: Text(total.toString()),
                            ),
                            Container(
                              width: 100,
                              child: caractere>1?Text(item['ordem']):Text(""),
                            )
                          ]));
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
