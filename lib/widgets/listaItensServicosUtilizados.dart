import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/controleController.dart';
import 'package:mip_app/global/app_text_styles.dart';

class ListaItensServicosUtilizados extends StatefulWidget {
  ListaItensServicosUtilizados({super.key});

  @override
  State<ListaItensServicosUtilizados> createState() =>
      _ListaItensServicosUtilizadosState();
}

class _ListaItensServicosUtilizadosState
    extends State<ListaItensServicosUtilizados> {
  final ControleController conCon = Get.put(ControleController());

  @override
  Widget build(BuildContext context) {
    print(conCon.index.value);
    return ListView.builder(
        itemCount: conCon.listaFinal.length,
        itemBuilder: (context, index) {
          var item = conCon.listaFinal;
          int quant = (item[index]['quant']);
          return InkWell(
              onTap: () {
                conCon.removerItemLicitado(conCon.listaFinal[index]);
              },
              child: Row(
                children: [
                  Flexible(
                      flex: 10,
                      fit: FlexFit.tight,
                      child: Text(
                        '${item[index]['nome']}',
                        overflow: TextOverflow.ellipsis,
                      )),
                  Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Text('${item[index]['unidade']}')),
                  Flexible(
                      flex: 2,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Container(
                                child: InkWell(
                                    onTap: () async {
                                      conCon.alteraQuant(
                                          conCon.listaFinal[index],
                                          index,
                                          false);
                                      setState(() {});
                                    },
                                    child:
                                        Icon(Icons.indeterminate_check_box))),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Container(
                                child: Text("${quant}",
                                    style: AppTextStyles.heading15)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Container(
                                child: InkWell(
                                    onTap: () async {
                                      conCon.alteraQuant(
                                          conCon.listaFinal[index],
                                          index,
                                          true);
                                      setState(() {});
                                    },
                                    child: Icon(Icons.add_box))),
                          ),
                        ],
                      )),
                ],
              ));
        });
  }
}
