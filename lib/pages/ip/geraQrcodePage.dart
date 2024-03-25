import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

// ignore: must_be_immutable
class GeraQrcodePage extends StatelessWidget {
  dynamic cod;
  GeraQrcodePage(this.cod, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("chegou");
    return Scaffold(
        body: Center(
            child: Container(
      height: 400,
      child: SfBarcodeGenerator(
        value: cod,
        symbology: QRCode(),
        showValue: false,
      ),
    )));
  }
}
