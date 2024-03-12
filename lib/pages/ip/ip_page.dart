import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/ipController.dart';
import 'package:mip_app/global/app_colors.dart';
import 'package:mip_app/global/app_text_styles.dart';
import 'package:mip_app/pages/ip/ip_detail.dart';

class IpPage extends StatefulWidget {
  const IpPage({super.key});

  @override
  State<IpPage> createState() => _IpPageState();
}

class _IpPageState extends State<IpPage> {
  final IpController conIp = Get.put(IpController());
  double alturaContainer = 120;
  double larguraContainer = 120;
  int index = 0;
  @override
  void initState() {
    super.initState();

    conIp.getIp();
  }

  @override
  Widget build(BuildContext context) {
    larguraContainer = (MediaQuery.of(context).size.width / 4);
    return Obx(
      () => Scaffold(
        appBar: AppBar(title: Text(conIp.textPage.value)),
        bottomNavigationBar: Container(
          height: 100,
          color: Colors.amber,
          child: Center(
            child: Text("Novo Ip"),
          ),
        ),
        body: _body(context),
      ),
    );
  }

  Column _body(BuildContext context) {




      switch (index) {

        case 0:
          conIp.listaIp..sort(((a, b) => (a["id"]).compareTo((b["id"]))));
          break;
          case 1:
        conIp.listaIp..sort(((a, b) => (b["id"]).compareTo((a["id"]))));
        break;

        case 2:
          conIp.listaIp..sort(((a, b) => (a["status"]).compareTo((b["status"]))));
          break;
        case 3:
          conIp.listaIp..sort(((a, b) => (b["status"]).compareTo((a["status"]))));
          break;


      }


    return Column(
        children: [
          Container(
            height: 200,
            child: Row(children: [
              demonstrativoIp(conIp.quantIp.value.toString(), 'total de ip'),
              demonstrativoIp(
                  conIp.quantIpNormal.value.toString(), 'Ip Normal'),
              demonstrativoIp(
                  conIp.quantIpDefeito.value.toString(), 'Ip Defeito'),
              demonstrativoIp(
                  conIp.quantIpAgendado.value.toString(), 'Ip Agendado'),
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
                width: 100,
                child: Row(
                  children: [
                    Text('cod'),
                    index==0
                        ? IconButton(onPressed: (){
                      setState(() {
                        index=1;
                      });
                    }, icon: Icon(Icons.arrow_circle_down)):IconButton(onPressed: (){
                      setState(() {
                        index=0;
                      });
                    }, icon: Icon(Icons.arrow_circle_up))
                  ],
                ),
              ),
              Container(
                width: 200,
                child: Text('Bairro'),
              ),
              Container(
                child: Text('Logradouro'),
              ),

              Spacer(),
              Container(
                width: 200,
                child: Text("tipo"),
              ),

              Container(
                width: 100,
                child: Row(
                  children: [
                    Text('Status'),
                    index!=2
                        ? IconButton(onPressed: (){
                      setState(() {
                        index=2;
                      });
                    }, icon: Icon(Icons.arrow_circle_down)):IconButton(onPressed: (){
                      setState(() {
                        index=3;
                      });
                    }, icon: Icon(Icons.arrow_circle_up))
                  ],
                ),
              ),
              Container(
                width: 100,
                child: Text("Ativo"),
              ),
            ]),
          ),
          Expanded(
            child: conIp.loading.value==false
                ? Container(
                    child: ListView.separated(
                      itemCount: conIp.listaIp.length,
                      itemBuilder: (context, index) {
                        var item = conIp.listaIp[index];



                        return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => IpDetail(item)),
                              );
                            },
                            child: Row(
                              children: [

                                Container(
                                  width: 100,
                                  child: Text(item['cod']),
                                ),
                                Container(
                                  width: 200,
                                  child: Text(item['Bairro']),
                                ),
                                Container(
                                  child: Text(item['logradouro']),
                                ),

                                Spacer(),
                                Container(
                                  width: 200,
                                  child: Text(item['tipo']),
                                ),

                                Container(
                                  width: 100,
                                  child: Text(item['status']),
                                ),
                                Container(
                                  width: 100,
                                  child: item['isAtivo']?Icon(Icons.circle,color: Colors.green):Icon(Icons.circle,color: Colors.red),


                                ),
                              ],
                            ));
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          thickness: 1,
                        );
                      },
                    ),
                  )
                : Container(
                    child: Center(
                    child: CupertinoActivityIndicator(),
                  )),
          ),
        ],
      );
  }

   demonstrativoIp(String valor, String title) {
    return LayoutBuilder(
      builder: (context,constraints) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: alturaContainer,
            width: larguraContainer-75,
            decoration:
                BoxDecoration(border: Border.all(width: 2, color: Colors.amber)),
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
    );
  }
}
