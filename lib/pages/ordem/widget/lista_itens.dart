import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListaItens extends StatelessWidget {
  dynamic ip;
  dynamic unidade;
  dynamic nome;
  dynamic quantidade;
  dynamic valor;
  dynamic total;

  ListaItens(
      this.ip, this.unidade, this.nome, this.quantidade, this.valor, this.total,
      {super.key});
  var formatador = NumberFormat("#,##0.00", "pt_BR");

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Text(ip == null ? "" : ip.toString())),
        Flexible(flex: 1, fit: FlexFit.tight, child: Text(unidade)),
        Flexible(flex: 4, fit: FlexFit.tight, child: Text(nome)),
        Flexible(
            flex: 1, fit: FlexFit.tight, child: Text(quantidade.toString())),
        Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Text('${formatador.format(valor)}')),
        Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Text('${formatador.format(total)}')),
      ],
    );
    ;
  }
}
