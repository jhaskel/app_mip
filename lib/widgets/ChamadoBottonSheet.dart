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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime crea = DateTime.parse(widget.chamado['createdAt']);
    return Container(
        padding: EdgeInsets.all(10),
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
                    Row(
                      children: [
                        Text(
                          "Chamado : ${widget.chamado['id']}",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
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
            SizedBox(
              width: 30,
            ),
            Divider(
              thickness: 2,
              color: Colors.blue,
            ),
            userRole == Util.roles[1] ||
                    userRole == Util.roles[4] ||
                    userRole == Util.roles[5]
                ? Container(
                    height: 50,
                    child: Row(
                      children: [
                        //button Agendar
                        widget.chamado['status'] == StatusApp.defeito.message
                            ? MaterialButton(
                                onPressed: () async {
                                  if (userRole == Util.roles[4]) {
                                    await conCha.alterarStatus(
                                        context,
                                        widget.chamado['id'],
                                        widget.chamado['idIp'],
                                        StatusApp.agendado.message,
                                        0.0);
                                    Get.back();
                                  } else {
                                    await Get.defaultDialog(
                                        title: 'Opps',
                                        content: Text("Sem autorização"));
                                    Get.back();
                                  }
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

                        //button concertar
                        widget.chamado['status'] == StatusApp.agendado.message ||  widget.chamado['status'] == StatusApp.concertando.message
                            ? MaterialButton(
                                onPressed: () async {
                                  if (userRole == Util.roles[1]) {
                                    await conCha.alterarStatus(
                                        context,
                                        widget.chamado['id'],
                                        widget.chamado['idIp'],
                                        StatusApp.concertando.message,
                                        0.0);
                                    Get.back();

                                    Get.to(ConsertandoPage(widget.chamado));
                                  } else {
                                    await Get.defaultDialog(
                                        title: 'Opps',
                                        content: Text("Sem autorização"));
                                    Get.back();
                                  }
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
                        //button normal
                        MaterialButton(
                          onPressed: () async {
                            await conCha.alterarStatus(
                                context,
                                widget.chamado['id'],
                                widget.chamado['idIp'],
                                StatusApp.normal.message,
                                0.0);
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
                        //button defeito
                        MaterialButton(
                          onPressed: () async {
                            await conCha.alterarStatus(
                                context,
                                widget.chamado['id'],
                                widget.chamado['idIp'],
                                StatusApp.defeito.message,
                                0.0);
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
                  )
                : Container(),
          ],
        ));
  }
}
