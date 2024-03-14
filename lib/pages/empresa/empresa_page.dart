import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mip_app/controllers/empresaController.dart';
import 'package:mip_app/global/app_colors.dart';
import 'package:mip_app/pages/empresa/empresa_detail.dart';


class EmpresaPage extends StatefulWidget {
  const EmpresaPage({Key? key}) : super(key: key);

  @override
  State<EmpresaPage> createState() => _EmpresaPageState();
}

class _EmpresaPageState extends State<EmpresaPage> {
  
  final EmpresaController conEmp = Get.put(EmpresaController());


  @override
  void initState() {
    super.initState();
    conEmp.getEmpresaAll(context);

  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(conEmp.textPage.value),
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
                child: conEmp.listEmpresas.length > 0
                    ? ListView.separated(
                        itemCount: conEmp.listEmpresas.length,
                        itemBuilder: (context, index) {
                          dynamic item = conEmp.listEmpresas[index];
                          return InkWell(
                            onTap: () {
                             Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EmpresaDetail(
                                        conEmp.listEmpresas[index])),
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
                        child: Text("Nenhuma Empresa Encontrada"),
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
