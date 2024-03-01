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
              onLongPress: () {
                Get.defaultDialog(
                    title: "Nome do Item",
                    content: Text('${item[index]['nome']}'));
              },
              onTap: () {
                conCon.removerItemLicitado(conCon.listaFinal[index]);
              },
              child: Column(
                children: [
                  ListTile(
                    dense: false,
                    title: Text(
                      '${item[index]['nome']}',
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                              child: InkWell(
                                  onTap: () async {
                                    conCon.alteraQuant(
                                        conCon.listaFinal[index], index, false);
                                    setState(() {});
                                  },
                                  child: Icon(Icons.indeterminate_check_box))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                              child: Text("${quant}",
                                  style: AppTextStyles.heading15White)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                              child: InkWell(
                                  onTap: () async {
                                    conCon.alteraQuant(
                                        conCon.listaFinal[index], index, true);
                                    setState(() {});
                                  },
                                  child: Icon(Icons.add_box))),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1,
                  )
                ],
              ));
        });
  }
}
