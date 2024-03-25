import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mip_app/controllers/cosipController.dart';
import 'package:mip_app/global/app_colors.dart';
import 'package:mip_app/global/app_text_styles.dart';
import 'package:mip_app/pages/Cosip/despesas/despesas_page.dart';
import 'package:mip_app/pages/Cosip/dotacao/dotacao_page.dart';
import 'package:mip_app/pages/Cosip/receitas/receitas_page.dart';

class CosipPage extends StatefulWidget {
  const CosipPage({Key? key}) : super(key: key);

  @override
  State<CosipPage> createState() => _CosipPageState();
}

class _CosipPageState extends State<CosipPage> {
  final CosipController conCos = Get.put(CosipController());

  double alturaContainer = 120;
  double larguraContainer = 120;
  int index = 0;
  var formatador = NumberFormat("#,##0.00", "pt_BR");

  inicia() async {
    await conCos.getDotacaoByAno("2024");
    await conCos.getReceitasCosipByAno("2024");
    conCos.getDespesasCosipByAno("2024");
  }

  @override
  void initState() {
    super.initState();
    inicia();
  }

  @override
  Widget build(BuildContext context) {
    print("index $index");
    return Scaffold(
      appBar: AppBar(
        title: Text('cosip'),
      ),
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    larguraContainer = (MediaQuery.of(context).size.width / 5);

    return Obx(() => Center(
          child: Column(
            children: [
              Container(
                height: 200,
                child: Row(children: [
                  demonstrativoIp(conCos.totalDotacao.value, 'Dotação', true),
                  demonstrativoIp(
                      conCos.totalReceitasCosipByAno.value, 'Receitas', true),
                  demonstrativoIp(
                      conCos.totalDespesasCosipByAno.value, 'Despesas', true),
                  demonstrativoIp(
                      conCos.receitaCaixa.value, 'Rec.Caixa', false),
                  demonstrativoIp(conCos.receitaOrcamentaria.value,
                      'Rec.Orçamentaria', false),
                ]),
              ),
              index>0?Container(height: 300,child: links(),):Container(height: 0,),
            ],
          ),
        ));
  }

   links() {
    if(index==1){
      return DotacaoPage();
    }else if(index ==2){
      return ReceitasPage();
    }else{
      return DespesasPage();
    }

  }

  demonstrativoIp(double valor, String title, bool link) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: alturaContainer,
            width: larguraContainer - 70,
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.amber)),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                '${formatador.format(valor)}',
                style: AppTextStyles.heading40White.copyWith(fontSize: 25),
              ),
              Text(title),
            ]),
          ),
        ),
        link
            ? Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  onPressed: () {
                    verificaTitle(title);
                  },
                  icon: Icon(
                    Icons.remove_red_eye_rounded,
                    color: AppColors.secundaria,
                  ),
                ))
            : Positioned(top: 10, right: 10, child: Text(""))
      ],
    );
  }

  verificaTitle(String title) {
    print("title $title");

    if (title == 'Dotação') {
      setState(() {
        index = 1;
      });
    } else if (title == 'Receitas') {
      setState(() {
        index = 2;
      });
    } else {
      setState(() {
        index = 3;
      });
    }
  }
}
