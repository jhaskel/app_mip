import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:mip_app/controllers/itemController.dart';
import 'package:mip_app/controllers/licitacaoController.dart';
import 'package:mip_app/controllers/ordemController.dart';
import 'package:mip_app/global/app_colors.dart';
import 'package:mip_app/pages/licitacao/licitacao_detail.dart';
import 'package:mip_app/pages/ordem/ordem_details.dart';

class LicitacaoPage extends StatefulWidget {
  const LicitacaoPage({Key? key}) : super(key: key);

  @override
  State<LicitacaoPage> createState() => _LicitacaoPageState();
}

class _LicitacaoPageState extends State<LicitacaoPage> {
  
  final LicitacaoController conLic = Get.put(LicitacaoController());
  var formatador = NumberFormat("#,##0.00", "pt_BR");

  @override
  void initState() {
    super.initState();
    conLic.getLicitacao(context);


  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(conLic.textPage.value),
        ),
        body: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          width: 2, color: AppColors.borderCabecalho),
                      bottom: BorderSide(
                          width: 2, color: AppColors.borderCabecalho))),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Container(width: 100, child: Text("homologado")),
                  Container(width: 100, child: Text("Processo")),
                  Container(child: Text("nome")),
                  Spacer(),
                  Container(width: 120, child: Text("prazo")),
                  Container(width: 100, child: Text("valor")),
                  Container(width: 100, child: Text("Ativo")),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                child: conLic.listLicitacoes.length > 0
                    ? ListView.separated(
                        itemCount: conLic.listLicitacoes.length,
                        itemBuilder: (context, index) {
                          dynamic item = conLic.listLicitacoes[index];
                          DateTime hoje=DateTime.now();
                          DateTime crea = DateTime.parse(item['homologadoAt']);

                          var processo = item['processo'];
                          var nome = item['alias'];
                          var valor = item['valor'];
                          var ativo = item['isAtivo'];
                          var prazo = item['prazo']+1;
                          var pzFinal = crea.add(Duration(days:prazo));
                          Duration diff = pzFinal.difference(hoje);

                          int dias = diff.inDays;

                          return InkWell(
                            onTap: () {
                             Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LicitacaoDetail(
                                        conLic.listLicitacoes[index],dias)),
                              );
                            },
                            child: Row(
                              children: [

                                Container(width: 100, child: Text(DateFormat("dd/MM/yy").format(crea))),
                                Container(width: 100, child: Text(processo)),
                                Container(child: Text(nome)),
                                Spacer(),
                                Container(width: 120, child: Text("${dias} dias",style: TextStyle(color: defineCor(dias)),)),
                                Container(width: 100, child: Text(
                                    'R\$ ${formatador.format(valor)}')),
                                Container(width: 100, child: ativo==1?Icon(Icons.circle,color: Colors.green,):Icon(Icons.circle,color: Colors.red,)),

                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            thickness: 1,
                          );
                        },
                      )
                    : Center(
                        child: Text("Nenhuma Licitacao Encontrada"),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  defineCor(int dias) {
    if(dias<=0){
      return Colors.red;
    }else if(dias >0 && dias <12){
      return Colors.orange;
    }else{
      return Colors.green;
    }
  }
}
