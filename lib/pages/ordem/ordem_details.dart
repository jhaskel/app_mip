import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:mip_app/controllers/itemController.dart';
import 'package:mip_app/controllers/ordemController.dart';
import 'package:mip_app/pages/controle/finalizando_page.dart';

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
  get item => widget.item;

  @override
  void initState() {
    super.initState();

    for (var x in item['itensOrdem']) {
      print(x);
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

    //listaItens.add(ix);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhe da Ordem ${item['cod']}'),
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            color: Colors.grey,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Flexible(flex: 1, fit: FlexFit.tight, child: Text("data")),
                Flexible(flex: 1, fit: FlexFit.tight, child: Text("cod")),
                Flexible(flex: 4, fit: FlexFit.tight, child: Text("status")),
                Flexible(flex: 1, fit: FlexFit.tight, child: Text("valor")),
              ],
            ),
          ),
          Container(
              height: 150,
              child: ListView.builder(
                  itemCount: conOrd.listaOrdens.length,
                  itemBuilder: (context, index) {
                    var item = conOrd.listaOrdens[index];
                    DateTime crea = DateTime.parse(item['modifiedAt']);

                    var cod = item['cod'];

                    var status = item['status'];

                    var valor = item['valor'];

                    return Row(
                      children: [
                        Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Text(DateFormat("dd/MM").format(crea))),
                        Flexible(flex: 1, fit: FlexFit.tight, child: Text(cod)),
                        Flexible(
                            flex: 4, fit: FlexFit.tight, child: Text(status)),
                        Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Text('R\$ ${formatador.format(valor)}')),
                      ],
                    );
                  })),
          Expanded(
            child: Container(
                color: Colors.white24,
                child: ListView.builder(
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
                          Flexible(
                              flex: 1, fit: FlexFit.tight, child: Text(cod)),
                          Flexible(
                              flex: 4, fit: FlexFit.tight, child: Text(nome)),
                          Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Text(unidade)),
                          Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Text(quantidade.toString())),
                          Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Text('R\$ ${formatador.format(valor)}')),
                          Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Text('R\$ ${formatador.format(total)}')),
                        ],
                      );
                    })),
          ),
        ],
      ),
    );
  }
}
