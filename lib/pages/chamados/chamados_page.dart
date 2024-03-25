import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mip_app/controllers/chamadoController.dart';
import 'package:mip_app/global/app_colors.dart';
import 'package:mip_app/global/app_text_styles.dart';
import 'package:mip_app/pages/chamados/chamado_page_detail.dart';

class ChamadosPage extends StatefulWidget {
  const ChamadosPage({super.key});

  @override
  State<ChamadosPage> createState() => _ChamadosPageState();
}

class _ChamadosPageState extends State<ChamadosPage> {
  final ChamadoController conCha = Get.put(ChamadoController());
  var formatador = NumberFormat("#,##0.00", "pt_BR");
  double alturaContainer = 120;
  double larguraContainer = 120;
  int index=0;

  @override
  void initState() {
    super.initState();
    conCha.getChamados(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Obx(
        () => Row(
          children: [
            Text("${conCha.textPage.value}"),
          ],
        ),
      )),
      body: _body(context),
    );
  }

  Container _body(BuildContext context) {
    switch (index) {
      case 0:
        conCha.listaChamados..sort(((a, b) => (a["id"]).compareTo((b["id"]))));
        break;
      case 1:
        conCha.listaChamados..sort(((a, b) => (b["id"]).compareTo((a["id"]))));
        break;

      case 2:
        conCha.listaChamados..sort(((a, b) => (a["idIp"]).compareTo((b["idIp"]))));
        break;
      case 3:
        conCha.listaChamados..sort(((a, b) => (b["idIp"]).compareTo((a["idIp"]))));
        break;

    }
    larguraContainer = (MediaQuery.of(context).size.width / 4) ;
    return Container(
      child: Obx(() => Column(
            children: [
              Container(
                height: 200,
                child: Row(children: [
                  demonstrativoChamado(conCha.quantChamados.value.toString(),
                      'Total de chamados'),
                  demonstrativoChamado(
                      conCha.chamadosAndamento.value.toString(),
                      'Chamados Andamento'),
                  demonstrativoChamado(
                      conCha.chamadosFinalizados.value.toString(),
                      'Chamados Finalizados'),
                  demonstrativoChamado(
                      conCha.gastosTotalChamados.value.toStringAsFixed(2),
                      'Gastos Total com Chamados'),
                ]),
              ),
              Container(
                height: 50,
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
                    child:  Row(
                      children: [
                        Text('Data'),
                        index==0
                            ? IconButton(onPressed: (){
                          setState(() {
                            index=1;
                          });
                        }, icon: Icon(Icons.arrow_circle_down)):IconButton(onPressed: (){
                          setState(() {
                            index=0;
                          });
                        }, icon: Icon(Icons.arrow_circle_up))
                      ],
                    ),
                  ),
                  Container(
                    width: 200,
                    child: Text("cod"),
                  ),
                  Container(
                    width: 100,
                    child:  Row(
                      children: [
                        Text('Ip'),
                        index!=2
                            ? IconButton(onPressed: (){
                          setState(() {
                            index=2;
                          });
                        }, icon: Icon(Icons.arrow_circle_down)):IconButton(onPressed: (){
                          setState(() {
                            index=3;
                          });
                        }, icon: Icon(Icons.arrow_circle_up))
                      ],
                    ),
                  ),
                  Container(
                    width: 100,
                    child: Text("Valor Gasto"),
                  ),
                  Spacer(),
                  Container(
                    width: 100,
                    child: Text("status"),
                  ),
                  Container(
                    width: 100,
                    child: Text("Concluído?"),
                  )
                ]),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: conCha.listaChamados.length,
                  itemBuilder: (context, index) {
                    var item = conCha.listaChamados[index];

                    DateTime crea = DateTime.parse(item['createdAt']);

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChamadoPageDetail(item)),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Container(
                              width: 100,
                              child: Text(DateFormat("dd/MM").format(crea)),
                            ),
                            Container(
                              width: 200,
                              child: Text(item['id']),
                            ),
                            Container(
                              width: 100,
                              child: Text(item['idIp']),
                            ),
                            Container(
                              width: 100,
                              child: Text(
                                  'R\$ ${formatador.format(item['total'])}'),
                            ),
                            Spacer(),
                            Container(
                              width: 100,
                              child: Text(item['status']),
                            ),
                            Container(
                              width: 100,
                              child: Icon(
                                Icons.circle,
                                color: item['isChamado']
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      thickness: 1,
                    );
                  },
                ),
              )
            ],
          )),
    );
  }

  Padding demonstrativoChamado(String valor, String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: alturaContainer,
        width: larguraContainer-75,
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
}
