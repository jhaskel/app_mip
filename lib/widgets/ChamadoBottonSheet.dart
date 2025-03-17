import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mip_app/controllers/chamadoController.dart';
import 'package:mip_app/global/global_var.dart';
import 'package:mip_app/pages/controle/consertando_page.dart';
import '../global/util.dart';

// ignore: must_be_immutable
class ChamadoBottonSheet extends StatefulWidget {
  dynamic chamado;

  ChamadoBottonSheet({required this.chamado});

  @override
  State<ChamadoBottonSheet> createState() => _ChamadoBottonSheetState();
}

class _ChamadoBottonSheetState extends State<ChamadoBottonSheet> {
  final ChamadoController conCha = Get.put(ChamadoController());
  var chamado;
  @override
  void initState() {
    chamado = widget.chamado.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime crea = DateTime.parse(chamado['createdAt']);
    print('chamado ${chamado['id']}');
    return Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        height: 300,
        width: 500,
        child: Column(
          children: [
            //inicio primeira parte do bottonsheet
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Chamado : ${chamado['id']}",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "IP : ${chamado['idIp']}",
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Defeito : ${chamado['defeito']}",
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Data : ${DateFormat("dd/MM").format(crea)}",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            //fim primeira parte do bottonsheet
            SizedBox(
              width: 30,
            ),
            Divider(
              thickness: 2,
              color: Colors.blue,
            ),
            userRole == Util.roles[1] ? _operador() : Container(),
            userRole == Util.roles[4] || userRole == Util.roles[5]
                ? _master()
                : Container(),
          ],
        ));
  }

  _operador() {
    return Row(
      children: [
        chamado['status'] == StatusApp.agendado.message ||
                chamado['status'] == StatusApp.concertando.message
            ? _buttonConsertar()
            : Container(),
        SizedBox(
          width: 10,
        ),
        chamado['status'] != StatusApp.concertado.message
            ? _buttonNormal()
            : Container(),
      ],
    );
  }

  _master() {
    return Row(
      children: [
        chamado['status'] == StatusApp.defeito.message
            ? _buttonAgendar()
            : Container(),
        SizedBox(
          width: 10,
        ),
        chamado['status'] != StatusApp.concertado.message
            ? _buttonNormal()
            : Container(),
      ],
    );
  }

  MaterialButton _buttonNormal() {
    return MaterialButton(
      onPressed: () async {
        await conCha.alterarStatus(context, chamado['id'], chamado['idIp'],
            StatusApp.normal.message, 0.0);

        await conCha.removeChamado(chamado['id'], context);

        Get.back();
      },
      color: Colors.amber,
      child: Text(
        "Normal",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  MaterialButton _buttonConsertar() {
    return MaterialButton(
      onPressed: () async {
        Get.to(ConsertandoPage(chamado));
      },
      color: Colors.green,
      child: Text(
        "Consertar",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  MaterialButton _buttonAgendar() {
    return MaterialButton(
      onPressed: () async {
        Navigator.pop(context);
        conCha.alterarStatus(context, chamado['id'], chamado['idIp'],
            StatusApp.agendado.message, 0.0);
      },
      color: Colors.blue,
      child: Text(
        "Agendar",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
