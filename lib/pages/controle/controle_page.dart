

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/chamadoController.dart';

import 'package:intl/intl.dart';
import 'package:mip_app/global/app_colors.dart';
import 'package:mip_app/global/global_var.dart';
import 'package:mip_app/pages/controle/autorizacao_page.dart';
import 'package:mip_app/pages/controle/finalizando_page.dart';
import 'package:mip_app/pages/ordem/create_ordem_home.dart';

import '../../global/util.dart';

class ControlePage extends StatefulWidget {
  const ControlePage({Key? key}) : super(key: key);

  @override
  State<ControlePage> createState() => _ControlePageState();
}

class _ControlePageState extends State<ControlePage> {
  final ChamadoController conCha = Get.put(ChamadoController());

  @override
  void initState() {

    super.initState();
    conCha.getChamadosLancado(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Controle',)
        ,actions: [
          userRole=="master"?Obx(
          ()=> IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AutorizacaoPage()),
              );
            },
            icon: Stack(
              children: [
                Icon(Icons.ac_unit_outlined),
                Positioned(
                  top: -5,
                    right: -5,

                    child: CircleAvatar(backgroundColor:Colors.white,radius:10,child: Text("${conCha.quantLancados.value}",style: TextStyle(color: Colors.red) ,)))
              ],
            )),
          ):Container(),SizedBox(width: 20,),
        userRole==Util.roles[4]||userRole==Util.roles[5]?IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateOrdemHome()),
              );
            },
            icon: Icon(Icons.table_chart)):Container(),


      ],
      ),
      body: Obx(
        () => Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          width: 2, color: AppColors.borderCabecalho),
                      bottom: BorderSide(
                          width: 2, color: AppColors.borderCabecalho))),
              height: conCha.alturaContainer.value,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Flexible(flex: 1, fit: FlexFit.tight, child: Text("Data")),
                  Flexible(flex: 2, fit: FlexFit.tight, child: Text("Defeito")),
                  Flexible(flex: 1, fit: FlexFit.tight, child: Text("Ip")),
                  Flexible(flex: 2, fit: FlexFit.tight, child: Text("Status")),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder(
                  stream: conCha.ref
                      .orderByChild('status')
                      .equalTo('realizado')
                      .onValue,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }else{
                      if (snapshot.data!.snapshot.value == null) {
                        if (snapshot.data!.snapshot.value == null) {
                          return Center(
                              child: Container(
                                child: Text("Nenhum Chamado Para esse IP"),
                              ));
                        }
                      }else{

                        Map maps = snapshot.data!.snapshot.value as Map;


                       var list = maps.values.toList()
                          ..sort(((a, b) => (b["modifiedAt"]).compareTo((a["modifiedAt"]))));
                        return Container(
                          child:  ListView.separated(
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              var item = list[index];
                              DateTime crea =
                              DateTime.parse(item['modifiedAt']);

                              return InkWell(
                                onTap: () {
                                  var t = Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FinalizandoPage(item)),
                                  );


                                },
                                child: Row(
                                  children: [
                                    Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Text(DateFormat("dd/MM")
                                            .format(crea))),
                                    Flexible(
                                        flex: 2,
                                        fit: FlexFit.tight,
                                        child: Text(item['defeito'])),
                                    Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Text(item['idIp'])),
                                    Flexible(
                                        flex: 2,
                                        fit: FlexFit.tight,
                                        child: Text(item['status'])),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider(
                                thickness: 1,
                              );
                            },
                          )


                        );
                      }

                    }
                  return Container();

                  }),
            ),
          ],
        ),
      ),
    );
  }
}
