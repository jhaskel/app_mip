import 'package:flutter/material.dart';
import 'package:mip_app/global/app_colors.dart';

class cabecalhoCreateOrdem extends StatelessWidget {
  const cabecalhoCreateOrdem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(width: 2, color: AppColors.borderCabecalho),
                bottom:
                    BorderSide(width: 2, color: AppColors.borderCabecalho))),
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: const Row(
          children: [
            Flexible(flex: 1, fit: FlexFit.tight, child: Text("cod")),
            Flexible(flex: 1, fit: FlexFit.tight, child: Text("unid.")),
            Flexible(flex: 4, fit: FlexFit.tight, child: Text("Nome")),
            Flexible(flex: 1, fit: FlexFit.tight, child: Text("quant.")),
            Flexible(flex: 1, fit: FlexFit.tight, child: Text("valor")),
            Flexible(flex: 1, fit: FlexFit.tight, child: Text("total")),
          ],
        ),
      ),
    );
  }
}
