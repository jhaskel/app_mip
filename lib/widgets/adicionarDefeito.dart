import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/chamadoController.dart';

class AdicionarDefeito extends StatelessWidget {
   bool isMapIp;

  AdicionarDefeito( {required this.isMapIp});
  final ChamadoController conCha = Get.put(ChamadoController());

  @override
  Widget build(BuildContext context) {
    return

      Obx(()=>
         Scaffold(
        body: _body(context),
            ),
      );


  }

  _body(BuildContext context) {
    print("${conCha.defeito.value}");
    print("${isMapIp}");

    if(isMapIp==true){
      return conCha.defeito.value == ''
          ? Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        child: MaterialButton(
          color: Colors.grey,
          onPressed:null,
          child: Text("Selecione um defeito"),
        ),
      )
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

    }else{
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
}
