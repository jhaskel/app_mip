import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/chamadoController.dart';
import 'package:mip_app/controllers/controleController.dart';
import 'package:mip_app/controllers/itemController.dart';
import 'package:mip_app/global/app_text_styles.dart';

class ListaItensServicosUtilizados extends StatefulWidget {
 String chamado;
  ListaItensServicosUtilizados(this.chamado, {super.key});

  @override
  State<ListaItensServicosUtilizados> createState() =>
      _ListaItensServicosUtilizadosState();
}

class _ListaItensServicosUtilizadosState
    extends State<ListaItensServicosUtilizados> {
  final ControleController conCon = Get.put(ControleController());
  final ItemController conIte = Get.put(ItemController());
  final ChamadoController conCha = Get.put(ChamadoController());

  @override
  Widget build(BuildContext context) {
    print(conCon.index.value);
   return StreamBuilder(
        stream: conIte.ref
            .orderByChild('chamado')
            .equalTo(widget.chamado)
            .onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }else{
            if (snapshot.data!.snapshot.value == null) {
              if (snapshot.data!.snapshot.value == null) {
                return Center(
                    child: Container(
                      child: Text("Nenhum Item Para esse Chamado"),
                    ));
              }
            }else{
              Map maps = snapshot.data!.snapshot.value as Map;
              var list = maps.values.toList()
                ..sort(((a, b) => (b["modifiedAt"]).compareTo((a["modifiedAt"]))));


              conCha.totalChamado.value=list.map((e) => e['total']).reduce((v, e) => v+e);


              return Container(
                child: Column(
                  children: [
                    Container(
                      height: 30,
                      child: Center(
                        child: Text(
                          'ITENS E SERVIÇOS UTILIZADOS - (${list.length}) itens',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                          child:  ListView.separated(
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              var item = list[index];
                             int quant = (item['quant']);

                              return InkWell(
                                  onTap: () {
                                    Get.defaultDialog(
                                        cancel: TextButton(onPressed: (){
                                          Get.back();
                                        }, child: Text("cancelar")),
                                        confirm: TextButton(
                                            onPressed: (){
                                              conIte.removeItemFirebase(item);
                                              Get.back();
                                            }, child: Text("Excluir")),
                                        title: "Nome do Item",
                                        content: Text('${item['nome']}'));

                                  },
                                  child: Column(
                                    children: [
                                      ListTile(
                                        dense: false,
                                        title: Text(
                                          '${item['nome']}',
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
                                                        conIte.alteraQuant(
                                                            item, false);
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
                                                        conIte.alteraQuant(
                                                            item, true);
                                                        setState(() {});
                                                      },
                                                      child: Icon(Icons.add_box))),
                                            ),
                                          ],
                                        ),
                                      ),

                                    ],
                                  ));
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return Divider(
                                thickness: 1,
                              );
                            },
                          )

                      ),
                    ),
                  ],
                ),
              );

            }

          }
          return Container();

        }
    );



  }
}
