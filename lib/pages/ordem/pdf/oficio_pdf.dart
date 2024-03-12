//Package imports
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mip_app/controllers/empresaController.dart';
import 'package:mip_app/controllers/licitacaoController.dart';
import 'package:mip_app/controllers/prefeituraController.dart';
import 'package:mip_app/global/save_web.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:async';
import 'package:intl/date_symbol_data_local.dart';

class OficioPdf extends StatefulWidget {

  String ordem;
  String oficio;
  double total;
  bool tipo;



  OficioPdf(this.ordem,this.oficio,this.total,this.tipo);
  @override
  _OficioPdfState createState() => _OficioPdfState();
}

class _OficioPdfState extends State<OficioPdf> {


  final PrefeituraController conPref = Get.put(PrefeituraController());
  final EmpresaController conEmp = Get.put(EmpresaController());
  final LicitacaoController conLic = Get.put(LicitacaoController());

  _gerar() async {
    await _createPDF();
    Get.back();
  }
  @override
  void initState() {
    initializeDateFormatting();


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

    //Create a new PDF document
    final PdfDocument document = PdfDocument();
    var formatador = NumberFormat("#,##0.00", "pt_BR");



    String setor = conPref.prefeitura['setor'];

    String responsavelIluminacao = conPref.prefeitura['contato'];

    String tipoDocumento = conPref.prefeitura['tipoDoc'];

    String cargo = conPref.prefeitura['cargo'];

    String nomeEntidade = conPref.prefeitura['nome'];

    String referente = widget.tipo==true?"compra de itens para manutenção da iluminação publica":"Serviços realizados para manutenção da iluminação publica";



    double valor = widget.total;



    String hoje = DateFormat('dd MMMM yyyy','pt_BR').format(DateTime.now());


    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 12);


     String cabecalho ='$tipoDocumento ${widget.oficio}/${DateTime.now().year}\nAo\n$setor\n$nomeEntidade';
     String data = '${conPref.prefeitura['municipio']} em ${hoje}';
    String titulo = 'Assunto:${conPref.prefeitura['nomeDocumento']}';
     String corpo =
        'Com nossos  cordiais cumprimentos, temos a grata satisfação de nos dirigirmos a vossa senhoria,'
         ' para solicitar a  ${conPref.prefeitura['nomeDocumento']}, referente $referente, conforme Processo Administrativo nº ${conLic.licitacao['processo']}  da empresa ${conEmp.empresa['nome']}, no valor de R\$ ${formatador.format(valor)}, conforme ordem ${widget.ordem} com os itens em anexo.';


    const String linha = '_______________________________________';
     String nomeresp =responsavelIluminacao;
     String cargoresp = cargo;
    //Draw the 0
    document.pages.add().graphics.drawString(
        cabecalho, contentFont,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(0, 70, 300, 70)
    );

    PdfPage page1 = document.pages[0];

    page1.graphics.drawString( data, contentFont, bounds: Rect.fromLTWH(0, 150, 500, 0),format: PdfStringFormat(
        alignment: PdfTextAlignment.right,
        ));
    page1.graphics.drawString( titulo, contentFont, bounds: Rect.fromLTWH(0, 200, 500, 0),format: PdfStringFormat(
        alignment: PdfTextAlignment.left,
        ));
    page1.graphics.drawString( corpo, contentFont, bounds: Rect.fromLTWH(0, 250, 500, 0),format: PdfStringFormat(
        paragraphIndent: 35,alignment: PdfTextAlignment.justify));
    //vem a tabela

    page1.graphics.drawString( linha, contentFont, bounds: Rect.fromLTWH(0, 550, 500, 0),format: PdfStringFormat(
        alignment: PdfTextAlignment.center,

        ));
    page1.graphics.drawString( nomeresp, contentFont, bounds: Rect.fromLTWH(0, 565, 500, 0),format: PdfStringFormat(
      alignment: PdfTextAlignment.center,
    ));
    page1.graphics.drawString( cargoresp, contentFont, bounds: Rect.fromLTWH(0, 580, 500, 0),format: PdfStringFormat(
      alignment: PdfTextAlignment.center,
    ));


    final PdfSection? section = document.sections?.add();
//Set the grid style


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
        'Ordem-${widget.ordem}',
        PdfStandardFont(PdfFontFamily.helvetica, 10),
        bounds: const Rect.fromLTWH(0, 0, 515, 50),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.right,
            lineAlignment: PdfVerticalAlignment.middle));
    headerElement.graphics
        .drawLine(PdfPens.gray, const Offset(0, 49), const Offset(515, 49));
    section?.template.top = headerElement;


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
        bytes, 'oficio nº ${widget.ordem}.pdf');
    //Launch file.
  }





}