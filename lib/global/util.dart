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
  encerrado(message: 'encerrado'); //status da mmanutencao

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
}
