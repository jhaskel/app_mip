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
      body: Center(
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
                conCha.idIp == ''
                    ? Container()
                    : Container(
                        height: 150,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: Defeito.values.length,
                              itemBuilder: (context, index) {
                                return defeitoWidged(index);
                              }),
                        ),
                      ),
              ],
            )),
      ),
    );
  }

  defeitoWidged(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          conCha.defeito(Defeito.values[index].message);
          conCha.createChamado(context);
        },
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.amber, width: 2)),
            width: 120,
            height: 100,
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
    );
  }
}
