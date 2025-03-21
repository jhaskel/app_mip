import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/chamadoController.dart';
import 'package:mip_app/global/app_colors.dart';
import 'package:mip_app/global/app_text_styles.dart';

class AdicionarDefeito extends StatelessWidget {
  bool isMapIp;

  AdicionarDefeito({required this.isMapIp});
  final ChamadoController conCha = Get.put(ChamadoController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: _body(context),
      ),
    );
  }

  _body(BuildContext context) {

    if (isMapIp == true) {
      return conCha.defeito.value == ''
          ? Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: MaterialButton(
                color: Colors.grey,
                onPressed: null,
                child: Text("Selecione um defeito"),
              ),
            )
          : Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: MaterialButton(
                color: AppColors.primaria,
                onPressed: () async {
                  print("XCXC01");

                  await conCha.createChamado(context);
                  Navigator.pop(context);
                },
                child: Text(
                  "Adicionar",
                  style: AppTextStyles.heading,
                ),
              ),
            );
    } else {
      return conCha.defeito.value == '' || conCha.idIp.value == ""
          ? Container()
          : Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: MaterialButton(
                color: Colors.amber,
                onPressed: () async {
                  print("XCXC02");

                 await conCha.createChamado(context);

                },
                child: Text("Adicionar"),
              ),
            );
    }
  }
}
