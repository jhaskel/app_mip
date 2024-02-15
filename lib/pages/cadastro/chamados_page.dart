import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/chamadoController.dart';

class ChamadosPage extends StatefulWidget {
  const ChamadosPage({super.key});

  @override
  State<ChamadosPage> createState() => _ChamadosPageState();
}

class _ChamadosPageState extends State<ChamadosPage> {
  final ChamadoController conCha = Get.put(ChamadoController());

  @override
  void initState() {
    super.initState();
    conCha.getChamados(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Obx(
        () => Row(
          children: [
            Text("${conCha.textPage.value}"),
            Spacer(),
            Text("tem ${conCha.listaChamados.length} chamados"),
          ],
        ),
      )),
      body: Container(
        child: Obx(() => Column(
              children: [
                Text("${conCha.textPage.value}"),
                Expanded(
                  child: ListView.builder(
                      itemCount: conCha.listaChamados.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Text(conCha.listaChamados[index]['id']),
                            SizedBox(
                              width: 10,
                            ),
                            Text(conCha.listaChamados[index]['idIp']),
                          ],
                        );
                      }),
                )
              ],
            )),
      ),
    );
  }
}
