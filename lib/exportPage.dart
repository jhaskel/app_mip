// ignore_for_file: public_member_api_docs

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';



class ExportPage extends StatefulWidget {
  const ExportPage(this.title);

  final String title;

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  @override

  void initState() {

    Map<String, String> vaccinated = {
      'dog': 'ready',
      'cat': 'ready',
      'mouse': 'done',
      'horse': 'done',
    };

    final total =
        vaccinated.entries.where((e) => e.value == "done").toList().length;

    print(total);

    super.initState();
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: PdfPreview(
          build: (format) => _generatePdf(format, widget.title),
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.ListView(
            children: [
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
              pw.Text(title),
            ],

          );
        },
      ),
    );

    return pdf.save();
  }
}