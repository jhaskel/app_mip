import 'package:flutter/material.dart';

class cabecalhoCreateOrdem extends StatelessWidget {
  const cabecalhoCreateOrdem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.white)),
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
