import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/controleController.dart';
import 'package:mip_app/controllers/itemController.dart';
import 'package:mip_app/global/app_text_styles.dart';
import 'package:mip_app/global/util.dart';

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
    print("idchamdo ${widget.chamado['id']}");
     conCon.getItens();
     conCon.getItensUtilizados(widget.chamado['id'].toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Finalizando Conserto ${widget.chamado['idIp']}",
        ),
        actions: [TextButton(onPressed: (){
          setState(() {
            conCon.getItens();
            print("de novo");

          });
        }, child: Text("de novo"))],
      ),
      body: _body(context),
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.amber,
        child: InkWell(onTap: (

            ) {

         conIte.createItem(context,conCon.listaFinal,StatusApp.lancado.message);
         conCon.index(0);




        }, child: Center(child: Text("Finalizar Lançamento",style: AppTextStyles.body20,))),
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
                            decoration: BoxDecoration( border: Border.all(color: Colors.amber, width: 2)),
                    child: ListView.builder(
                        itemCount: conCon.listaItens.length,
                        itemBuilder: (context, index) {
                          var item = conCon.listaItens[index];
                          final nome = item['nome'].toString();

                          return InkWell(
                              onTap: () {
                                String chamado = widget.chamado['id'];
                                String nome = item['nome'].toString();

                                String created = DateTime.now().toIso8601String();

                                String id = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString();
                                String idIp = widget.chamado['idIp'];

                                String unidade = item['unidade'].toString();
                                String operador = 'paulo Haskel';
                                String ordem = '20240214-1';
                                final nomeitem = item['nome'].toString();
                                double valor = item['valor'];
                                int quantidade = item['quantidade'];
                                int estoque = item['estoque'];
                                String idItem = item['id'].toString();

                                print("quantidade $quantidade");
                                if (estoque <= 0) {
                                  Get.defaultDialog(
                                      title: "OOps",
                                      content: Text('Estoque é insuficiente')
                                  );
                                } else {
                                  print("Estoque suficiente");
                                  var iten = {
                                    'chamado': chamado,
                                    'nome': nomeitem,
                                    'createdAt': created,
                                    'modifiedAt': DateTime.now().toString(),
                                    'id': id,
                                    'idIp': idIp,
                                    'idItem': idItem,
                                    'estoque': estoque,

                                    'operador': operador,
                                    'tipo': 1,
                                    'ordem': ordem,
                                    'unidade': unidade,
                                    'quant': 1,
                                    'valor': valor,
                                    'total': valor,
                                  };


                                  conCon.adicionarItemLicitado(iten);
                                }
                              },
                              child: Text('$nome'));
                        }),
                  ),
              )
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    height: 250,
                            decoration: BoxDecoration( border: Border.all(color: Colors.amber, width: 2)),
                    child: ListView.builder(
                        itemCount: conCon.listaServicos.length,
                        itemBuilder: (context, index) {
                          var item = conCon.listaServicos[index];
                          final nome = item['nome'].toString();


                          return InkWell(
                              onTap: () {
                                String chamado = widget.chamado['id'];
                                String nome = item['nome'].toString();

                                String created = DateTime.now().toIso8601String();

                                String id = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString();
                                String idIp = widget.chamado['idIp'];

                                String operador = 'paulo kjhj';
                                String ordem = '20240214-2';
                                final nomeitem = item['nome'].toString();
                                String idItem = item['id'].toString();

                                String unidade = item['unidade'];

                                double valor = item['valor'];
                                int quantidade = item['quantidade'];
                                int estoque = item['estoque'];
                                print("estoque $estoque");
                                print("estoque $nomeitem");

                                print("quantidade $quantidade");
                                if (estoque <= 0) {

                                  Get.defaultDialog(
                                    title: "OOps",
                                    content: Text('Estoque é insuficiente')
                                  );

                                } else {
                                  print("Estoque suficiente");
                                  var iten = {
                                    'chamado': chamado,
                                    'nome': nomeitem,
                                    'createdAt': created,
                                    'modifiedAt': DateTime.now().toString(),
                                    'id': id,
                                    'idIp': idIp, //id do Ip
                                    'idItem': idItem, //id do Ip
                                    'estoque': estoque,

                                    'operador': operador,
                                    'unidade': unidade,
                                    'tipo': 2,
                                    'ordem': ordem,
                                    'quant': 1,
                                    'valor': valor,
                                    'total': valor,
                                  };


                                  conCon.adicionarItemLicitado(iten);
                                }
                              },
                              child: Text('$nome'));
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
                decoration: BoxDecoration( border: Border.all(color: Colors.amber, width: 2)),
                padding: EdgeInsets.all(5),

                child: ListView.builder(
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
                                  child: Text('${item[index]['nome']}',overflow: TextOverflow.ellipsis,)),
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
                                                      conCon.listaFinal[index],index,
                                                      false);
                                                  setState(() {

                                                  });
                                                },
                                                child: Icon(Icons
                                                    .indeterminate_check_box))),
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
                                                      conCon.listaFinal[index],index,
                                                      true,);
                                                  setState(() {

                                                  });

                                                },
                                                child: Icon(Icons.add_box))),
                                      ),
                                    ],
                                  )),
                            ],
                          ));
                    }),
              ),
            ),
          )
        ],
      ),
    );
  }


}
