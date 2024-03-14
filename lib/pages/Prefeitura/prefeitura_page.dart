import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mip_app/controllers/prefeituraController.dart';
import 'package:mip_app/global/app_colors.dart';
import 'package:mip_app/pages/Prefeitura/prefeitura_detail.dart';



class PrefeituraPage extends StatefulWidget {
  const PrefeituraPage({Key? key}) : super(key: key);

  @override
  State<PrefeituraPage> createState() => _PrefeituraPageState();
}

class _PrefeituraPageState extends State<PrefeituraPage> {
  
  final PrefeituraController conPre = Get.put(PrefeituraController());


  @override
  void initState() {
    super.initState();
    conPre.getPrefeituraAll(context);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(conPre.textPage.value),
        ),
        body: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          width: 2, color: AppColors.borderCabecalho),
                      bottom: BorderSide(
                          width: 2, color: AppColors.borderCabecalho))),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Container(width: 150, child: Text("cnpj")),
                  Container(child: Text("nome")),
                  Spacer(),
                  Container(width: 100, child: Text("Ativo")),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                child: conPre.listPrefeituras.length > 0
                    ? ListView.separated(
                        itemCount: conPre.listPrefeituras.length,
                        itemBuilder: (context, index) {
                          dynamic item = conPre.listPrefeituras[index];
                          return InkWell(
                            onTap: () {
                             Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PrefeituraDetail(
                                        conPre.listPrefeituras[index])),
                              );
                            },
                            child: Row(
                              children: [

                                Container(width: 150, child: Text(item['cnpj'])),
                                Container(child: Text(item['nome'])),
                                Spacer(),
                                Container(width: 100, child: item['isAtivo']==1?Icon(Icons.circle,color: Colors.green,):Icon(Icons.circle,color: Colors.red,)),

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
                    : Center(
                        child: Text("Nenhuma Prefeitura Encontrada"),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  defineCor(int dias) {
    if(dias<=0){
      return Colors.red;
    }else if(dias >0 && dias <12){
      return Colors.orange;
    }else{
      return Colors.green;
    }
  }
}
