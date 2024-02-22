import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/chamadoController.dart';
import 'package:mip_app/global/util.dart';

class DefeitoList extends StatelessWidget {
  final int index;

  DefeitoList({required this.index});

  @override
  Widget build(BuildContext context) {
    return defeitoWidged(index);
  }
}

defeitoWidged(int index) {
  final ChamadoController conCha = Get.put(ChamadoController());
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector(
      onTap: () async {
        conCha.defeito(Defeito.values[index].message);

        conCha.indexDefeito(index);
      },
      child: Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.amber, width: 2)),
          width: 80,
          height: 80,
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
