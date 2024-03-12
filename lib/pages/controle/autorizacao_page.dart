import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/chamadoController.dart';
import 'package:intl/intl.dart';
import 'package:mip_app/controllers/ipController.dart';
import 'package:mip_app/global/app_colors.dart';
import 'package:mip_app/pages/chamados/chamado_details.dart';

class AutorizacaoPage extends StatefulWidget {
  const AutorizacaoPage({Key? key}) : super(key: key);

  @override
  State<AutorizacaoPage> createState() => _AutorizacaoPageState();
}

class _AutorizacaoPageState extends State<AutorizacaoPage> {
  final AutorizacaoPage conAut = Get.put(AutorizacaoPage());
  final ChamadoController conCha = Get.put(ChamadoController());
  final IpController conIp = Get.put(IpController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Autorização'),
        actions: [
          IconButton(onPressed: (){
            setState(() {

            });
          }, icon: Icon(Icons.refresh))
        ],
      ),
      body: Obx(
        () => Column(
          children: [
            Container(height: 40,child: Text(conCha.loading.value.toString()),),
            Container(
              height: conCha.alturaContainer.value,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          width: 2, color: AppColors.borderCabecalho),
                      bottom: BorderSide(
                          width: 2, color: AppColors.borderCabecalho))),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Flexible(flex: 1, fit: FlexFit.tight, child: Text("Data")),
                  Flexible(flex: 2, fit: FlexFit.tight, child: Text("Chamado")),
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
                      .equalTo('lancado')
                      .onValue,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
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
                        child: Center(
                          child:  ListView.separated(
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              var item = list[index];
                              DateTime crea = DateTime.parse(item['modifiedAt']);

                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChamadoDetails(
                                          item,
                                        )),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Text(
                                            DateFormat("dd/MM").format(crea))),
                                    Flexible(
                                        flex: 2,
                                        fit: FlexFit.tight,
                                        child: Text(item['id'])),
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
                            separatorBuilder: (BuildContext context, int index) {
                              return Divider(
                                thickness: 1,
                              );
                            },
                          )

                        ),
                      );

                    }

                  }
                  return Container();


                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}

