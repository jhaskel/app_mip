import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/ipController.dart';
import 'package:mip_app/global/app_text_styles.dart';
import 'package:mip_app/pages/ip/geraQrcodePage.dart';
import 'package:mip_app/pages/ip/ip_detail.dart';
import 'package:mip_app/pages/maps/mapsIpUnico.dart';
import 'package:mip_app/pages/ordem/create_ordem_Itens.dart';
import 'package:mip_app/pages/ordem/create_ordem_servicos.dart';

class IpDetailPage extends StatefulWidget {

  dynamic item;
  IpDetailPage(this.item, {super.key});

  @override
  State<IpDetailPage> createState() => _IpDetailPageState();
}

class _IpDetailPageState extends State<IpDetailPage>

    with SingleTickerProviderStateMixin {
  get item => widget.item;
  final IpController conIp = Get.put(IpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      showDialogQrcode(item);
                    },
                    icon: Icon(Icons.qr_code))
              ],
              bottom:  TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                padding: EdgeInsets.only(bottom: 10),
                indicatorWeight: 4,
                labelColor: Colors.amber,
                unselectedLabelColor: Colors.white60,
                labelStyle: AppTextStyles.heading15,
                tabs: [
                  Tab(text: 'Chamados'),
                  Tab(text: 'IP',),
                ],
              ),
              title: Text("${conIp.textPage.value} ${item['id']}"),
            ),
            body: TabBarView(
              children: [
                MapsIpUnico(item),
                IpDetail(item),


              ],
            ),
          ),
        ),);
  }



  modalBottomSheet(
    context,
  ) {}

  Future<void> showDialogQrcode(dynamic item) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("${item['cod']}"),
          content:
          Container(width: 400, height: 400, child: GeraQrcodePage(item['cod'])),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('cancelar')),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // conCard.alterar(id,context);
                },
                child: Text('OK')),
          ],
        );
      },
    );
  }
}
