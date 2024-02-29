import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/controleController.dart';

class ListaItensLicitados extends StatefulWidget {
  dynamic item;
  String nome;
  int tipo;
  dynamic chamado;
  ListaItensLicitados(this.item, this.nome, this.tipo, this.chamado,
      {super.key});

  @override
  State<ListaItensLicitados> createState() => _ListaItensLicitadosState();
}

class _ListaItensLicitadosState extends State<ListaItensLicitados> {
  final ControleController conCon = Get.put(ControleController());
  get item => widget.item;
  get nome => widget.nome;
  get tipo => widget.tipo;
  get chamado => widget.chamado;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          int estoque = item['estoque'];
          if (estoque <= 0) {
            Get.defaultDialog(
                title: "OOps", content: Text('Estoque é insuficiente'));
          } else {
            print("Estoque suficiente");
            var iten = {
              'chamado': chamado['id'],
              'nome': nome,
              'createdAt': DateTime.now().toString(),
              'modifiedAt': DateTime.now().toString(),
              'id': DateTime.now().millisecondsSinceEpoch.toString(),
              'idIp': chamado['idIp'],
              'idItem': item['id'].toString(),
              'estoque': estoque,
              'user': "Paulo Almeida",
              'tipo': tipo,
              'ordem': "$tipo",
              'unidade': item['unidade'].toString(),
              'cod': item['cod'],
              'quant': 1,
              'valor': item['valor'],
              'total': item['valor'],
            };

            conCon.adicionarItemLicitado(iten);
          }
        },
        child: Text('$nome'));
  }
}
