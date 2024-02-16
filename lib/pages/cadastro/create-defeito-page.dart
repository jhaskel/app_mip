import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/chamadoController.dart';
import 'package:mip_app/controllers/ipController.dart';
import 'package:mip_app/global/util.dart';

class CreateDefeitoPage extends StatefulWidget {
  const CreateDefeitoPage({super.key});

  @override
  State<CreateDefeitoPage> createState() => _CreateDefeitoPageState();
}

class _CreateDefeitoPageState extends State<CreateDefeitoPage> {
  final ChamadoController conCha = Get.put(ChamadoController());
  final IpController conIp = Get.put(IpController());

  @override
  void initState() {
    conIp.getIp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastrar")),
      body: LayoutBuilder(builder: (context, constraints) {
        return Center(
          child: Obx(() => Column(
                children: [
                  InkWell(
                      onTap: () {},
                      child: Text(
                          "${conIp.textAppBar.value} ${conIp.listaIp.length}")),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownSearch<String>(
                      selectedItem: 'Selecione uma Luminária',
                      items: conIp.postes.values.toList(),
                      onChanged: (v) {
                        var id = conIp.postes.keys.firstWhere(
                            (k) => conIp.postes[k] == v,
                            orElse: () => "null");

                        conCha.idIp.value = id;
                        conCha.codIp.value = v!;
                      },
                      popupProps: const PopupPropsMultiSelection.menu(
                        isFilterOnline: false,
                        showSelectedItems: true,
                        showSearchBox: true,
                      ),
                    ),
                  ),
                  Container(
                    height: constraints.maxHeight - 185,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: GridView.builder(
                        itemCount: Defeito.values.length,
                        itemBuilder: (context, index) {
                          return defeitoWidged(index);
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
                          childAspectRatio: 1,
                        ),
                      ),
                    ),
                  ),
                  conCha.defeito.value == '' || conCha.idIp.value == ""
                      ? Container()
                      : Container(
                          height: 100,
                          width: constraints.maxWidth,
                          child: MaterialButton(
                            color: Colors.amber,
                            onPressed: () {
                              conCha.createChamado(context);
                            },
                            child: Text("Adicionar"),
                          ),
                        )
                ],
              )),
        );
      }),
    );
  }

  defeitoWidged(int index) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            conCha.defeito(Defeito.values[index].message);

            conCha.indexDefeito(index);
          },
          child: Container(
              decoration: BoxDecoration(
                  color: conCha.indexDefeito == index
                      ? Colors.cyan
                      : Colors.transparent,
                  border: Border.all(color: Colors.amber, width: 2)),
              width: conCha.alturaWidget.value,
              height: conCha.alturaWidget.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${Defeito.values[index].message}",
                  ),
                  Icon(Util.icones[index]),
                ],
              )),
        ),
      ),
    );
  }
}
