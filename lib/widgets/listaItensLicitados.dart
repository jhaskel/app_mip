import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/controleController.dart';
import 'package:mip_app/controllers/itemController.dart';
import 'package:mip_app/global/global_var.dart';

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
  final ItemController conIte = Get.put(ItemController());
  get item => widget.item;
  get nome => widget.nome;
  get tipo => widget.tipo;
  get chamado => widget.chamado;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {

            var id = DateTime.now().millisecondsSinceEpoch.toString();
            var iten = {
              'chamado': chamado['id'],
              'nome': nome,
              'createdAt': DateTime.now().toString(),
              'modifiedAt': DateTime.now().toString(),
              'id': "id${id}",
              'idIp': chamado['idIp'],
              'idItem': item['id'].toString(),
              'estoque': item['estoque'],
              'ordenacao': item['ordenacao'],
              'user': userName,
              'tipo': tipo,
              'autorizado': false,
              'ordem': "$tipo",
              'unidade': item['unidade'].toString(),
              'cod': item['cod'],
              'quant': 1,
              'valor': item['valor'],
              'total': item['valor'],
              'licitacao': item['licitacao'],
              'empresa': item['empresa'],
            };

            conIte.adicionarItemLicitado(iten);

        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                '$nome',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text('${item['unidade']}'),
            ),
            Divider(
              thickness: 1,
            )
          ],
        ));
  }
}
