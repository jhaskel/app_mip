import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/chamadoController.dart';
import 'package:mip_app/widgets/adicionarDefeito.dart';
import 'package:mip_app/widgets/defeitos_list.dart';
import '../global/util.dart';

class IpDetails extends StatefulWidget {
  String id;
  double latitude;
  double longitude;
  String status;

  IpDetails(
      {required this.id,
      required this.latitude,
      required this.longitude,
      required this.status});

  @override
  State<IpDetails> createState() => _IpDetailsState();
}

class _IpDetailsState extends State<IpDetails> {
  final ChamadoController conCha = Get.put(ChamadoController());

  @override
  void initState() {
    conCha.lati(widget.latitude);
    conCha.longi(widget.longitude);
    conCha.idIp(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: Colors.black87,
        width: conCha.alturaContainerDetails.value,
        child: Wrap(
          children: <Widget>[
            ListTile(
                leading: new Icon(Icons.music_note),
                title: new Text('Ip: ${widget.id}'),
                onTap: () => {}),
            ListTile(
              leading: new Icon(Icons.videocam),
              title: new Text('Status ${widget.status}'),
              onTap: () => {},
            ),
            Container(
              height: 120,
              child: Padding(
                padding: EdgeInsets.all(4),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: Defeito.values.length,
                  itemBuilder: (context, index) {
                    return DefeitoList(
                      index: index,
                    );
                  },
                ),
              ),
            ),
            Container(height: 50, child: AdicionarDefeito(isMapIp: true))
          ],
        ),
      ),
    );
  }
}
