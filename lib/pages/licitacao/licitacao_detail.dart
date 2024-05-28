import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mip_app/controllers/chamadoController.dart';
import 'package:mip_app/controllers/empresaController.dart';
import 'package:mip_app/controllers/ipController.dart';
import 'package:mip_app/controllers/itemController.dart';
import 'package:mip_app/controllers/licitacaoController.dart';
import 'package:mip_app/global/app_text_styles.dart';
import 'package:mip_app/pages/chamados/chamado_page_detail.dart';
import 'package:mip_app/pages/licitacao/itensByChamados.dart';

import '../../global/app_colors.dart';

class LicitacaoDetail extends StatefulWidget {
  dynamic item;
  int dias;
  LicitacaoDetail(this.item, this.dias, {super.key});

  @override
  State<LicitacaoDetail> createState() => _LicitacaoDetailState();
}

class _LicitacaoDetailState extends State<LicitacaoDetail> {
  get item => widget.item;

  final LicitacaoController conLic = Get.put(LicitacaoController());
  final EmpresaController conEmp= Get.put(EmpresaController());

    var formatador = NumberFormat("#,##0.00", "pt_BR");


@override
  void initState() {
    super.initState();
    conEmp.getEmpresa(context, item['empresa']);


  }
  @override
  Widget build(BuildContext context) {

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text("${conLic.textPageDetail.value}"),
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
    DateTime crea = DateTime.parse(item['homologadoAt']);
    double largura = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height: 200,
          child: Row(
            children: [
              Container(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titulos('Processo'),
                    titulos('Empresa'),
                    titulos('CNPJ'),
                    titulos('Homoloado em'),
                    titulos('Validade'),
                    titulos('Valor'),
                    titulos('Objeto'),
                  ],
                ),
              ),
              Container(
                width: largura-200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titulos('${item['processo']}'),
                    titulos('${conEmp.nomeEmpresa.value}'),
                    titulos('${conEmp.cnpjEmpresa.value}}'),
                    titulos('${DateFormat("dd/MM/yy").format(crea)}'),
                    titulos('${widget.dias}'),
                    titulos('R\$ ${formatador.format(item['valor'])}'),
                    titulos('${item['objeto']}'),
                  ],
                ),
              ),
            ],
          ),
        ),


        Expanded(
          child: StreamBuilder(
            stream: conLic.refLicItens.orderByChild('licitacao').equalTo(item['id']).onValue,
            builder: (context, snapshott) {
              if (!snapshott.hasData) {
                return Center(child: CupertinoActivityIndicator());
              } else {
                if (snapshott.data!.snapshot.value == null) {
                  return Center(
                      child: Container(
                    child: Text("Nenhum Chamado Para esse IP"),
                  ));
                } else {

                  Map<dynamic, dynamic> maps = snapshott.data!.snapshot.value as Map;
                  List<dynamic> list = [];
                  list.clear();
                  list = maps.values.toList();
                  list = maps.values.toList()
                    ..sort(((a, b) => (a["cod"]).compareTo((b["cod"]))));


                  return Column(
                    children: [

                      Obx(() => Container(
                            height: conLic.alturaContainer.value,
                            width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    width: 2, color: AppColors.borderCabecalho),
                                bottom: BorderSide(
                                    width: 2, color: AppColors.borderCabecalho))),
                            child: Row(children: [
                              Container(
                                width: 50,
                                child: Text('cod'),
                              ),
                              Container(
                                width: 75,
                                child: Text("unid."),
                              ),
                              Container(

                                child: Text("nome"),
                              ),
                              Spacer(),

                              Container(
                                width: 75,
                                child: Text("quant."),
                              ),
                              Container(
                                width: 100,
                                child: Text("valor"),
                              ),

                              Container(
                                width: 100,
                                child: Text("estoque"),
                              ),
                              Container(
                                width: 100,
                                child: Text("Ativo"),
                              ),
                            ]),
                          )),
                      Expanded(
                        child: ListView.separated(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            var item = list[index];

                            return InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ItensByChamado(item)),
                                );
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(children: [
                                    Container(
                                      width: 50,
                                      child: Text(item['cod'].toString()),
                                    ),
                                    Container(
                                      width: 75,
                                      child: Text(item['unidade']),
                                    ),
                                    Container(

                                      child: Text(item['nome']),
                                    ),

                                    Spacer(),

                                    Container(
                                      width: 75,
                                      child: Text(item['quantidade'].toString()),
                                    ),
                                    Container(
                                      width: 100,
                                      child: Text("R\$ ${formatador.format(item['valor'])}"),
                                    ),

                                    Container(
                                      width: 100,
                                      child: Text(item['estoque'].toString()),
                                    ),
                                    Container(
                                      width: 100,
                                      child: item['estoque']>0
                                          ? Icon(
                                              Icons.circle,
                                              color: Colors.green,
                                            )
                                          : Icon(
                                              Icons.circle,
                                              color: Colors.red,
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
          ),
        ),
      ],
    );
  }
}

class titulos extends StatelessWidget {
  String texto;
   titulos(this.texto
  );

  @override
  Widget build(BuildContext context) {
    return Text("$texto: ",style: AppTextStyles.bodyTitleBold,overflow: TextOverflow.ellipsis,maxLines: 2,);
  }
}
