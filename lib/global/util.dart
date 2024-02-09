class Util {}

enum StatusApp {
  normal(message: 'normal'), //status do poste
  defeito(message: 'defeito'), //status do poste
  agendado(message: 'agendado'), //status do poste
  concertando(message: 'concertando'), //status do poste
  realizado(message: 'realizado'), //status da mmanutencao
  lancado(message: 'lancado'), //status da mmanutencao
  autorizado(message: 'autorizado'); //status da mmanutencao

  const StatusApp({required this.message});
  final String message;
}

enum Defeito {
  apagado(message: 'apagado'),
  oscilando(message: 'oscilando'),
  ascendeApaga(message: 'ascente/apaga'),
  torto(message: 'torto');

  const Defeito({required this.message});
  final String message;
}
