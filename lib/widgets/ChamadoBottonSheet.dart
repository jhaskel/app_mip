import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/chamadoController.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        height: 300,
        width: 500,
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "IP : ${widget.chamado['idIp']}",
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Defeito : ${widget.chamado['defeito']}",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Row(
              children: [
                widget.chamado['status'] == StatusApp.defeito.message
                    ? MaterialButton(
                        onPressed: () async {
                          await conCha.alterarStatus(
                              widget.chamado['id'],
                              widget.chamado['idIp'],
                              StatusApp.agendado.message);
                          Get.back();
                        },
                        color: Colors.blue,
                        child: Text(
                          "Agendar",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : Container(),
                SizedBox(
                  width: 10,
                ),
                widget.chamado['status'] == StatusApp.agendado.message
                    ? MaterialButton(
                        onPressed: () async {
                          await conCha.alterarStatus(
                              widget.chamado['id'],
                              widget.chamado['idIp'],
                              StatusApp.concertando.message);
                          Get.back();

                          Get.to(ConsertandoPage(widget.chamado));
                        },
                        color: Colors.green,
                        child: Text(
                          "Consertar",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : Container(),
                SizedBox(
                  width: 10,
                ),
                MaterialButton(
                  onPressed: () async {
                    await conCha.alterarStatus(widget.chamado['id'],
                        widget.chamado['idIp'], StatusApp.normal.message);
                    Get.back();
                  },
                  color: Colors.amber,
                  child: Text(
                    "Normal",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                MaterialButton(
                  onPressed: () async {
                    await conCha.alterarStatus(widget.chamado['id'],
                        widget.chamado['idIp'], StatusApp.defeito.message);
                    Get.back();
                  },
                  color: Colors.red,
                  child: Text(
                    "Defeito",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
