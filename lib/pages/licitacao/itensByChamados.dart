
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/licitacaoController.dart';
import 'package:mip_app/global/app_colors.dart';
import 'package:mip_app/global/app_text_styles.dart';


class ItensByChamado extends StatefulWidget {
   dynamic item;
   ItensByChamado(this.item, {super.key});

  @override
  State<ItensByChamado> createState() => _ItensByChamadoState();
}

class _ItensByChamadoState extends State<ItensByChamado> {
  final LicitacaoController conLic = Get.put(LicitacaoController());
  double alturaContainer = 120;
  double larguraContainer = 120;
  int total = 0;

  @override
  Widget build(BuildContext context) {

    return
       Scaffold(
         appBar: AppBar(title:Text(widget.item['nome'] ),),
        body: _body()

    );
  }

  _body() {
    return  StreamBuilder(
      stream: conLic.refIte.orderByChild('idItem').equalTo(widget.item['id'].toString()).onValue,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        if (snapshot.data!.snapshot.value == null) {
          return Column(
            children: [
              Container(
                height: 200,
                child: Row(children: [

                  demonstrativoChamado(
                      total.toString(),
                      'Total de Itens Utilizados'),
                ]),
              ),
              Expanded(
                child: Center(
                    child: Container(
                      child: Text("Esse item Não foi utilizado!"),
                    )),
              ),
            ],
          );
        }
         Map<dynamic, dynamic> maps = snapshot.data!.snapshot.value as Map;
        List<dynamic> list = [];
        list.clear();
        list = maps.values.toList();
        total = list.length;


        return Column(
          children: [
            Container(
              height: 200,
              child: Row(children: [

                demonstrativoChamado(
                    total.toString(),
                    'Total de Itens Utilizados'),

              ]),
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          width: 2, color: AppColors.borderCabecalho),
                      bottom: BorderSide(
                          width: 2, color: AppColors.borderCabecalho))),
              child: Row(children: [

                Container(
                  width: 150,
                  child: Text("Chamado"),
                ),
                Container(
                  width: 150,
                  child: Text("IP"),
                ),

                Container(
                  width: 75,
                  child: Text("quant."),
                ),


              ]),
            ),
            Expanded(
              child:
              ListView.separated(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  var item = list[index];


                  return Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(children: [

                        Container(
                          width: 150,
                          child: Text(item['chamado']),
                        ),
                        Container(
                          width: 150,
                          child: Text(item['idIp']),
                        ),



                        Container(
                          width: 75,
                          child: Text(item['quant'].toString()),
                        ),



                      ]));
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    thickness: 1,
                  );
                },
              ),
            ),
          ],
        );
      }
    );
  }
  Padding demonstrativoChamado(String valor, String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: alturaContainer,
        width: MediaQuery.of(context).size.width-75,
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: AppColors.primaria)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            valor,
            style: AppTextStyles.heading40White.copyWith(fontSize: 30),
          ),
          Text(title),
        ]),
      ),
    );
  }

}
