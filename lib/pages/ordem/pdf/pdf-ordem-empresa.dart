

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mip_app/controllers/empresaController.dart';
import 'package:mip_app/controllers/licitacaoController.dart';
import 'package:mip_app/controllers/prefeituraController.dart';
import 'package:mip_app/global/save_web.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:async';


class PdfOrdemEmpresa extends StatefulWidget {
  List<dynamic> list;

  PdfOrdemEmpresa(this.list, {Key? key}) : super(key: key);

  @override
  State<PdfOrdemEmpresa> createState() => _PdfOrdemEmpresaState();
}

class _PdfOrdemEmpresaState extends State<PdfOrdemEmpresa> {

  final PrefeituraController conPref = Get.put(PrefeituraController());
  final EmpresaController conEmp = Get.put(EmpresaController());
  final LicitacaoController conLic = Get.put(LicitacaoController());
  _gerar() async {
    await _createPDF();
    Get.back();
  }

  @override
  void initState() {
    _gerar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
                TextButton(onPressed: null, child: Text('Algo deu Errado!'))));
  }

  Future<void> _createPDF() async {
   // final ConfigController conConf = Get.put(ConfigController());

    //Create a new PDF document
    final PdfDocument document = PdfDocument();

    var formatador = NumberFormat("#,##0.00", "pt_BR");
    // var tot = widget.list.map((e) => e['produto']['total']);
    //  var tota = tot.reduce((a, b) => a+b);
    //  var total = formatador.format(tota);
    var total = 0.0;
    for (var x in widget.list) {
      var to = x['quant'] * x['valor'];
      total = total + to;
    }
    //total = formatador.format(1256);

        //   var t = widget.licitacao.first['licitacao'];
  //  print("tttttttttt $t");

    //Draw the text
    final PdfSection? section = document.sections?.add();

    PdfGrid grid = PdfGrid();
//Add the columns to the grid
    grid.columns.add(count: 6);
//Add header to the grid
    grid.headers.add(4);
//Add the rows to the grid
    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Ordem  ${widget.list.first['ordem']}';

    PdfGridRow headerFor = grid.headers[1];
    headerFor.cells[0].value = 'Processo Administrativo nº ${conLic.licitacao['processo']}';

    PdfGridRow headerCnpj = grid.headers[2];
    headerCnpj.cells[0].value = '${conEmp.empresa['nome']} ';

    PdfGridRow header1 = grid.headers[3];
    header1.cells[0].value = 'Cod';
    header1.cells[1].value = 'Unid';
    header1.cells[2].value = 'Item';
    header1.cells[3].value = 'Qde';
    header1.cells[4].value = 'Valor';
    header1.cells[5].value = 'Total';

    header.cells[0].columnSpan = 6;
    headerFor.cells[0].columnSpan = 6;
    headerCnpj.cells[0].columnSpan = 6;

    header.height = 30;
    headerFor.height = 25;
    headerCnpj.height = 25;

//Add rows to grid

    for (var item in widget.list) {
      var totalPro = item['quant'] * item['valor'];
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = item['cod'].toString();

      row.cells[1].value = item['unidade'];

      row.cells[2].value = item['nome'];

      row.cells[3].value = item['quant'].toString();

      row.cells[4].value = 'R\$ ${formatador.format(item['valor'])}';

      row.cells[5].value = 'R\$ ${formatador.format(totalPro)}';
    }

    PdfGridRow row2 = grid.rows.add();
    row2.cells[0].value = 'Total da ordem';
    row2.cells[1].value = '';
    row2.cells[2].value = '';
    row2.cells[3].value = '';
    row2.cells[4].value = '';
    row2.cells[5].value = 'R\$ ${formatador.format(total)}';

    PdfGridRow row4 = grid.rows.add();
    row4.cells[0].value = '';
    row4.height = 30;

    PdfGridRow row5 = grid.rows.add();
    row5.cells[0].value = '';
    row5.height = 30;

    PdfGridRow row6 = grid.rows.add();
    row6.cells[0].value = '';
    row6.height = 30;

    PdfGridRow row7 = grid.rows.add();
    row7.cells[0].value = conPref.prefeitura['contato'];
    row7.height = 20;

    PdfGridRow row8 = grid.rows.add();
   row8.cells[0].value = conPref.prefeitura['cargo'];
    row8.height = 20;

    row2.cells[0].columnSpan = 5;
    row4.cells[0].columnSpan = 6;
    row5.cells[0].columnSpan = 6;
    row6.cells[0].columnSpan = 6;
    row7.cells[0].columnSpan = 6;
    row8.cells[0].columnSpan = 6;

    //define tamanhos das colunas
    grid.columns[0].width = 35;
    grid.columns[1].width = 45;
    grid.columns[3].width = 35;
    grid.columns[4].width = 70;
    grid.columns[5].width = 70;

    header1.style = PdfGridRowStyle(
        backgroundBrush: PdfBrushes.dimGray,
        textPen: PdfPens.white,
        textBrush: PdfBrushes.darkOrange,
        font: PdfStandardFont(
          PdfFontFamily.timesRoman,
          12,
        ));

    header.style = PdfGridRowStyle(
      textPen: PdfPens.black,
      font: PdfStandardFont(PdfFontFamily.timesRoman, 18),
    );

    header.cells[4].style.stringFormat = PdfStringFormat(
      alignment: PdfTextAlignment.center,
    );

    row7.cells[0].style.stringFormat = PdfStringFormat(
      alignment: PdfTextAlignment.center,
    );
    row8.cells[0].style.stringFormat = row7.cells[0].style.stringFormat;
    header.cells[5].style.font =
        (PdfStandardFont(PdfFontFamily.timesRoman, 12));
    row7.cells[0].style.font = (PdfStandardFont(PdfFontFamily.timesRoman, 9));
    row8.cells[0].style.font = (PdfStandardFont(PdfFontFamily.timesRoman, 9));

    PdfStringFormat format2 = PdfStringFormat();
    format2.alignment = PdfTextAlignment.center;

    header.cells[0].stringFormat = format2;
    headerFor.cells[0].stringFormat = format2;
    headerCnpj.cells[0].stringFormat = format2;
    header1.cells[0].stringFormat = format2;
    header.cells[0].style.borders = PdfBorders(
        left: PdfPen(PdfColor(255, 255, 255), width: 0),
        top: PdfPen(PdfColor(255, 255, 255), width: 0),
        bottom: PdfPen(PdfColor(255, 255, 255), width: 0),
        right: PdfPen(PdfColor(255, 255, 255), width: 0));
    header.cells[5].style.borders = header.cells[0].style.borders;
    headerFor.cells[0].style.borders = header.cells[0].style.borders;
    headerCnpj.cells[0].style.borders = header.cells[0].style.borders;
    row4.cells[0].style.borders = header.cells[0].style.borders;
    row5.cells[0].style.borders = header.cells[0].style.borders;
    row6.cells[0].style.borders = header.cells[0].style.borders;
    row7.cells[0].style.borders = header.cells[0].style.borders;
    row8.cells[0].style.borders = header.cells[0].style.borders;

//Set the grid style
    grid.style = PdfGridStyle(
        cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 4),
        textBrush: PdfBrushes.black,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 12));

    //Create a PdfLayoutFormat for pagination
    PdfLayoutFormat format = PdfLayoutFormat(
        breakType: PdfLayoutBreakType.fitColumnsToPage,
        layoutType: PdfLayoutType.paginate);

//Draw the grid

    //Create a header template and draw a text.
    final PdfPageTemplateElement headerElement = PdfPageTemplateElement(
      const Rect.fromLTWH(0, 0, 515, 50),
    );
    headerElement.graphics.setTransparency(0.6);
    headerElement.graphics.drawString(
        'Ordem-${widget.list.first['ordem']}',
        PdfStandardFont(PdfFontFamily.helvetica, 10),
        bounds: const Rect.fromLTWH(0, 0, 515, 50),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.right,
            lineAlignment: PdfVerticalAlignment.middle));
    headerElement.graphics
        .drawLine(PdfPens.gray, const Offset(0, 49), const Offset(515, 49));
    section?.template.top = headerElement;

    grid.draw(
      page: document.pages.add(),
      bounds: Rect.fromLTWH(0, 0, 0, 700),
      format: format,
    );

//Saves the document

    //Create a footer template and draw a text.
    final PdfPageTemplateElement footerElement = PdfPageTemplateElement(
      const Rect.fromLTWH(0, 0, 515, 50),
    );
    footerElement.graphics.setTransparency(0.6);
    PdfCompositeField(text: 'Pag. {0} de {1}', fields: <PdfAutomaticField>[
      PdfPageNumberField(brush: PdfBrushes.black),
      PdfPageCountField(brush: PdfBrushes.black)
    ]).draw(footerElement.graphics, const Offset(450, 35));
    section?.template.bottom = footerElement;
    //Add a new PDF page

    //Save the document
    final List<int> bytes = document.saveSync();
    //Dispose the document.
    document.dispose();
    //Save and launch the file.
    await FileSaveHelper.saveAndLaunchFile(
        bytes, 'Ordem nº ${widget.list.first['ordem']}.pdf');
  }
}
