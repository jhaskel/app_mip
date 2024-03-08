import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:mip_app/controllers/itemController.dart';
import 'package:mip_app/controllers/ordemController.dart';
import 'package:mip_app/global/app_colors.dart';
import 'package:mip_app/global/app_text_styles.dart';
import 'package:mip_app/pages/ordem/pdf/pdf-ordem-empresa.dart';

// ignore: must_be_immutable
class OrdemDetails extends StatefulWidget {
  dynamic item;

  OrdemDetails(this.item, {Key? key}) : super(key: key);

  @override
  State<OrdemDetails> createState() => _OrdemDetailsState();
}

class _OrdemDetailsState extends State<OrdemDetails> {
  final ItemController conIte = Get.put(ItemController());
  final OrdemController conOrd = Get.put(OrdemController());
  var formatador = NumberFormat("#,##0.00", "pt_BR");

  List<dynamic> listaItens = [].obs;
  List<Map<String, dynamic>> list=[];
  get item => widget.item;

  @override
  void initState() {
    super.initState();
  //  list.addAll(item);



    for (var x in item['itensOrdem']) {
      var cod = "";
      if (x['cod'] != null) {
        cod = x['cod'].toString();
      }

      var s = {
        "cod": cod,
        "nome": x['nome'],
        "quant": x['quant'],
        "total": x['total'],
        "unidade": x['unidade'],
        "valor": x['valor'],
      };

     listaItens.add(s);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhe da Ordem ${item['cod']}'),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PdfOrdemEmpresa(
                      listaItens,)),
            );

          }, icon: Icon(Icons.picture_as_pdf)),
          IconButton(onPressed: () {}, icon: Icon(Icons.picture_as_pdf_sharp))
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            height: 210,
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.amber, width: 2)),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    child: Text("cod"),
                  ),
                  Container(
                    child: Text(item['cod']),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    child: Text("valor"),
                  ),
                  Container(
                    child: Text('R\$ ${formatador.format(item['valor'])}'),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    child: Text("Solicitação de Fornecimento"),
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () {},
                      child: Text("emitir"),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    child: Text("Nota Fiscal"),
                  ),
                  Container(
                    child: Tooltip(
                      message: 'Visualizar',
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.remove_red_eye_sharp),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    child: Text("Status"),
                  ),
                  Container(
                    child: TextButton(
                        onPressed: () {

                          setState(() {

                          });
                        }, child: Text(item['status'])),
                  ),
                ],
              ),
            ]),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(width: 2, color: AppColors.borderCabecalho),
                    bottom: BorderSide(
                        width: 2, color: AppColors.borderCabecalho))),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Container(
                  width: 100,
                  child: Text(
                    "cod",
                    style: AppTextStyles.bodyWhite20,
                  ),
                ),
                Container(
                  width: 100,
                  child: Text(
                    "unidade",
                    style: AppTextStyles.bodyWhite20,
                  ),
                ),
                Text(
                  "nome",
                  style: AppTextStyles.bodyWhite20,
                ),
                Spacer(),

                Container(
                  width: 100,
                  child: Text(
                    "quant",
                    style: AppTextStyles.bodyWhite20,
                  ),
                ),

                Container(
                  width: 100,
                  child: Text(
                    "valor",
                    style: AppTextStyles.bodyWhite20,
                  ),
                ),
                Container(
                  width: 100,
                  child: Text(
                    "total",
                    style: AppTextStyles.bodyWhite20,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
                padding: EdgeInsets.all(10),
                child: ListView.separated(
                  itemCount: listaItens.length,
                  itemBuilder: (context, index) {
                    var item = listaItens[index];

                    var cod = item['cod'];
                    var nome = item['nome'];
                    var unidade = item['unidade'];
                    var quantidade = item['quant'];
                    var valor = item['valor'];
                    var total = item['total'];

                    return Row(
                      children: [
                        Container(width:100,child: Text(cod)),
                        Container(width:100, child: Text(unidade)),
                        Container( child: Text(nome)),
                        Spacer(),

                        Container(width:100,
                            child: Text(quantidade.toString())),
                        Container(width:100,
                            child: Text('R\$ ${formatador.format(valor)}')),
                        Container(width:100,
                            child: Text('R\$ ${formatador.format(total)}')),
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      thickness: 1,
                    );
                  },
                )),
          )
        ],
      ),
    );
  }
}
