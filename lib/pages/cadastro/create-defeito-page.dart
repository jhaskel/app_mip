import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/chamadoController.dart';
import 'package:mip_app/controllers/ipController.dart';
import 'package:mip_app/global/util.dart';
import 'package:mip_app/widgets/adicionarDefeito.dart';
import 'package:mip_app/widgets/defeitos_list.dart';

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
    super.initState();
    conIp.getIp();
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
                      onChanged: (v) async {
                        var id = conIp.postes.keys.firstWhere(
                            (k) => conIp.postes[k] == v,
                            orElse: () => "null");

                        conCha.idIp.value = id;
                        conCha.codIp.value = v!;

                        await conCha.getIpUnico(conCha.idIp.value);
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
                          return DefeitoList(
                            index: index,
                          );
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
                  Container(height: 100, child: AdicionarDefeito()),
                ],
              )),
        );
      }),
    );
  }
}
