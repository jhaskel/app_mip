import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/prefeituraController.dart';
import 'package:mip_app/global/app_text_styles.dart';

class PrefeituraDetail extends StatefulWidget {
  dynamic item;

  PrefeituraDetail(this.item,  {super.key});

  @override
  State<PrefeituraDetail> createState() => _PrefeituraDetailState();
}

class _PrefeituraDetailState extends State<PrefeituraDetail> {
  get item => widget.item;
  final PrefeituraController conPre= Get.put(PrefeituraController());

  @override
  Widget build(BuildContext context) {
print("empress $item");
    return  Scaffold(
        appBar: AppBar(
          title: Text("Detalhe da Prefeitura"),
        ),
        body: _body(),

    );
  }

  _body() {
    double largura = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(

          child: Row(
            children: [
              Container(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titulos('CNPJ'),
                    titulos('nome'),
                    titulos('Municipio'),
                    titulos('email'),
                    titulos('fone'),
                    titulos('Sigla'),
                    titulos('Responsavel'),
                    titulos('Cargo'),
                    titulos('Tipo Documento'),
                    titulos('Responsavel Compras'),
                    titulos('Nome Documento'),
                    titulos('setor'),
                    titulos('Ativo'),
                  ],
                ),
              ),
              Container(
                width: largura-200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titulos('${item['cnpj']}'),
                    titulos('${item['nome']}'),
                    titulos('${item['municipio']}'),
                    titulos('${item['email']}'),
                    titulos('${item['fone']}'),
                    titulos('${item['siglaIp']}'),
                    titulos('${item['contato']}'),
                    titulos('${item['cargo']}'),
                    titulos('${item['tipoDoc']}'),
                    titulos('${item['responsavelCompras']}'),
                    titulos('${item['nomeDocumento']}'),
                    titulos('${item['setor']}'),

                    Icon(Icons.circle,color: item['isAtivo']==true?Colors.green:Colors.red,)
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
