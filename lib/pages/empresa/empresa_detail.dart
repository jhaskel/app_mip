import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mip_app/controllers/empresaController.dart';
import 'package:mip_app/global/app_text_styles.dart';
import 'package:mip_app/pages/chamados/chamado_page_detail.dart';
import '../../global/app_colors.dart';

class EmpresaDetail extends StatefulWidget {
  dynamic item;

  EmpresaDetail(this.item,  {super.key});

  @override
  State<EmpresaDetail> createState() => _EmpresaDetailState();
}

class _EmpresaDetailState extends State<EmpresaDetail> {
  get item => widget.item;
  final EmpresaController conEmp= Get.put(EmpresaController());

  @override
  Widget build(BuildContext context) {
print("empress $item");
    return  Scaffold(
        appBar: AppBar(
          title: Text("Detalhe da Empresa"),
        ),
        body: _body(),

    );
  }


  _body() {

    double largura = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height: 200,
          child: Row(
            children: [
              Container(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titulos('Nome'),
                    titulos('CNPJ'),
                    titulos('Ativo'),
                  ],
                ),
              ),
              Container(
                width: largura-200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titulos('${item['nome']}'),
                    titulos('${item['cnpj']}'),
                    Icon(Icons.circle,color: item['isAtivo']==1?Colors.green:Colors.red,)
                  ],
                ),
              ),
            ],
          ),
        ),


      ],
    );
  }
}

class titulos extends StatelessWidget {
  String texto;
   titulos(this.texto
  );

  @override
  Widget build(BuildContext context) {
    return Text("$texto: ",style: AppTextStyles.bodyTitleBold,overflow: TextOverflow.ellipsis,maxLines: 2,);
  }
}
