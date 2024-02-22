import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/chamadoController.dart';

class AdicionarDefeito extends StatelessWidget {
  const AdicionarDefeito({super.key});

  @override
  Widget build(BuildContext context) {
    final ChamadoController conCha = Get.put(ChamadoController());
    return conCha.defeito.value == '' || conCha.idIp.value == ""
        ? Container()
        : Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: MaterialButton(
              color: Colors.amber,
              onPressed: () async {
                conCha.createChamado(context);
              },
              child: Text("Adicionar"),
            ),
          );
  }
}
