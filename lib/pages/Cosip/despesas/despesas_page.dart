import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mip_app/controllers/cosipController.dart';
import 'package:mip_app/global/app_colors.dart';
import 'package:mip_app/pages/Cosip/despesas/create_despesa_page.dart';

class DespesasPage extends StatefulWidget {
  const DespesasPage({Key? key}) : super(key: key);

  @override
  State<DespesasPage> createState() => _DespesasPageState();
}

class _DespesasPageState extends State<DespesasPage> {
  final CosipController conCos = Get.put(CosipController());
  String ano = DateTime.now().year.toString();
  var formatador = NumberFormat("#,##0.00", "pt_BR");
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      
      children: [
        Container(height: 33,child: Padding(
          padding:  EdgeInsets.only(left: 10),
          child: Row(
            children: [
              const Text("DESPESAS"),
               IconButton(onPressed: (){
                 Get.defaultDialog(
                     title: "Nova Receita",
                     content: CreateDespesaPage(conCos: conCos),
                     onConfirm: () {
                       conCos.createdDespesaEnegia(context);
                       Get.back();
                     },
                     onCancel: () {
                       //      idPedido(0);
                     });

               },icon: Icon(Icons.add_circle,color: AppColors.primaria,)),
            ],
          ),
        ),),
        Container(
          height: 30,
          child: Padding(
            padding: const EdgeInsets.only(right: 10,left: 10),
            child: Row(
              children: [
                Container(width: 200,child: Text("Mes"),),
                Container(child: Text("Dotacao"),),
                Spacer(),
                Container(width: 100,child: Align(alignment:Alignment.centerRight,child: Text("Valor")),),
              ],
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder(
              stream: conCos.ref.child('despesas').child(ano).onValue,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(),
                  );

                if (snapshot.data?.snapshot.value == null)
                  return Center(
                    child: Text("Nenhum registro encontrado!"),
                  );


                  Map<dynamic, dynamic> maps = snapshot.data!.snapshot.value as Map;
                List<dynamic> list = [];

                list.clear();
                list = maps.values.toList();

                return ListView.separated(
                  itemCount: list.length,
                  itemBuilder: (context,index){
                    var item = list[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 10,left: 10),
                      child: Row(
                        children: [
                          Container(width: 200,child: Text(item['mes']),),
                          Container(child: Text(item['dotacao']),),
                          Spacer(),
                          Container(width: 100,child: Align(alignment:Alignment.centerRight,child: Text('${formatador.format(item['valor'])}'))),
                        ],
                      ),
                    );

                  }, separatorBuilder: (BuildContext context, int index) { return Divider(thickness: 1,); },

                );

              }
          ),
        ),
      ],
    );
  }
}
