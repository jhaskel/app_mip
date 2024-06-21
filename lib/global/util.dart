import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum StatusApp {
  normal(message: 'normal'), //status do poste
  defeito(message: 'defeito'), //status do poste
  agendado(message: 'agendado'), //status do poste
  concertando(message: 'concertando'), //status do poste
  realizado(message: 'realizado'), //status da mmanutencao
  lancado(message: 'lancado'), //status da mmanutencao
  autorizado(message: 'autorizado'), //status da mmanutencao
  ordemGerada(message: 'ordem Gerada'),
  ordemConfirmada(message: 'ordem Confirmada'),
  gerandoSF(message: 'gerando SF'),
  SfGerada(message: 'SF gerada'),
  aguardandoNota(message: 'Aguardando Nota'),
  notaGerada(message: 'Nota Gerada'),
  tesouraria(message: 'tesouraria'), //status da mmanutencao
  concluido(message: 'concluido'); //status da mmanutencao

  const StatusApp({required this.message});
  final String message;
}

enum Defeito {
  apagado(message: 'apagada'),
  oscilando(message: 'oscilando'),
  ascendeApaga(message: 'ascende/apaga'),
  torto(message: 'torta/suja'),
  quebrada(message: 'Quebrada/pendurada'),
  acesa(message: 'Acesa durante o dia'),
  destruida(message: 'destruida/poste quebrado'),
  ;

  const Defeito({required this.message});
  final String message;
}

class Util {
  static final icones = <IconData>[
    MdiIcons.lightbulbOff,
    MdiIcons.lightbulbOn10,
    MdiIcons.lightbulbOutline,
    MdiIcons.trackLight,
    MdiIcons.hail,
    MdiIcons.lightbulb,
    MdiIcons.jira,
    MdiIcons.sack,
  ];

  static List roles = <String>[
    "user",//contribuinte 0
    "operador",//quem realiza o concerto 1
    "supervisor",//superviso da empresa 2
    "admin",//secretario, servidor da prefeitura 3
    "master",//responsavel IP 4
    "dev"//manutenção do sistema 5
  ];
  static List meses = <String>[
    "zero","jan","fev","mar","abr","mai","jun","Jul","ago",'set','out','nov','dez'

  ];

  static List cores = <Color>[
    Colors.yellow,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.orange,
  ];

  static final Map<String, Color> corStatus = {
    StatusApp.normal.message: cores[0],
    StatusApp.defeito.message: cores[1],
    StatusApp.agendado.message: cores[2],
    StatusApp.concertando.message: cores[3],
    StatusApp.realizado.message: cores[4],
    StatusApp.lancado.message: cores[5],

  };
}
