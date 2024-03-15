import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';
import 'package:mip_app/controllers/empresaController.dart';
import 'package:mip_app/controllers/itemController.dart';
import 'package:mip_app/controllers/licitacaoController.dart';
import 'package:mip_app/controllers/ordemController.dart';
import 'package:mip_app/controllers/prefeituraController.dart';
import 'package:mip_app/global/app_colors.dart';
import 'package:mip_app/global/app_text_styles.dart';
import 'package:mip_app/pages/ordem/pdf/oficio_pdf.dart';
import 'package:mip_app/pages/ordem/pdf/pdf-ordem-empresa.dart';


// ignore: must_be_immutable
class OrdemDetails extends StatefulWidget {
  dynamic item;

  OrdemDetails(this.item, {Key? key}) : super(key: key);

  @override
  State<OrdemDetails> createState() => _OrdemDetailsState();
}

class _OrdemDetailsState extends State<OrdemDetails> {
  final ItemController conIte = Get.put(ItemController());
  final OrdemController conOrd = Get.put(OrdemController());
  final PrefeituraController conPref = Get.put(PrefeituraController());
  final EmpresaController conEmp = Get.put(EmpresaController());
  final LicitacaoController conLic = Get.put(LicitacaoController());
  var formatador = NumberFormat("#,##0.00", "pt_BR");
  TextEditingController numero = TextEditingController();

  List<dynamic> listaItens = [].obs;
  List<Map<String, dynamic>> list = [];
  get item => widget.item;
  String licitacao = '';
  String empresa = '';
  String tipo = '1';

  XFile? imageFile;
  String urlOfUploadedImage = "";
  chooseImageFromGallery() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
      });
    }
  }

  lici(String id) async {
    await conLic.getLicitacaoById(context, id);
    licitacao = (conLic.licitacao['processo']);
  }

  empre(String id) async {
    await conEmp.getEmpresa(context, id);
    empresa = (conLic.licitacao['empresa']);
  }

  @override
  void initState() {
    super.initState();
    conPref.getPrefeitura(context);

    lici(item['itensOrdem'][0]['licitacao']);
    empre(item['itensOrdem'][0]['empresa']);

    tipo = item['id'][item['id'].length - 1];
    print("tipo $tipo");

    for (var x in item['itensOrdem']) {
      var cod = "";
      if (x['cod'] != null) {
        cod = x['cod'].toString();
      }
      var s = {
        "cod": cod,
        "nome": x['nome'],
        "quant": x['quant'],
        "total": x['total'],
        "unidade": x['unidade'],
        "valor": x['valor'],
        "ordem": item['cod'],
      };
      listaItens.add(s);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhe da Ordem ${item['cod']}'),
        actions: [
          IconButton(
              onPressed: () {
                print("07");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PdfOrdemEmpresa(listaItens)),
                );
              },
              icon: Icon(Icons.picture_as_pdf)),
          IconButton(
              onPressed: () {
                Get.defaultDialog(
                    title: "Numero do Documento",
                    content: TextFormField(
                      autofocus: true,
                      focusNode: FocusNode(),
                      keyboardType:
                      TextInputType.number,
                      maxLength: 2,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers can be entered


                      controller: numero,
                    ),
                    cancel: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(Icons.cancel)),
                    confirm: IconButton(
                        onPressed: () {

                          var ofc = numero.text;

                          Navigator.pop(context);

                          if (ofc.length > 0) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OficioPdf(
                                      item['cod'],
                                      numero.text,
                                      item['valor'],
                                      tipo == "1" ? true : false)),
                            );
                          } else {
                            Get.defaultDialog(
                                title: 'Defina um numero',
                                content: Text(
                                    "Obrigatório definir um numero para o documento"),
                             );
                          }
                        },
                        icon: Icon(Icons.check_circle)));
              },
              icon: Icon(Icons.picture_as_pdf_sharp))
        ],
      ),
      body: Column(
        children: [
          imageFile == null
              ? const CircleAvatar(
            radius: 86,
            backgroundImage:
            AssetImage("assets/images/avatarman.png"),
          )
              : Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
                image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: FileImage(
                      File(imageFile!.path),
                    ))),
          ),
          InkWell(
            onTap: () {
              chooseImageFromGallery();
            },
            child: const Text("Select Image",
                style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: EdgeInsets.all(10),
            height: 210,
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.amber, width: 2)),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    child: Text("cod"),
                  ),
                  Container(
                    child: Text(item['cod']),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    child: Text("valor"),
                  ),
                  Container(
                    child: Text('R\$ ${formatador.format(item['valor'])}'),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    child: Text("Solicitação de Fornecimento"),
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () {},
                      child: Text("emitir"),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    child: Text("Nota Fiscal"),
                  ),
                  Container(
                    child: Tooltip(
                      message: 'Visualizar',
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.remove_red_eye_sharp),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    child: Text("Status"),
                  ),
                  Container(
                    child: TextButton(
                        onPressed: () {
                          setState(() {});
                        },
                        child: Text(item['status'])),
                  ),
                ],
              ),
            ]),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(width: 2, color: AppColors.borderCabecalho),
                    bottom: BorderSide(
                        width: 2, color: AppColors.borderCabecalho))),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Container(
                  width: 100,
                  child: Text(
                    "cod",
                    style: AppTextStyles.bodyWhite20,
                  ),
                ),
                Container(
                  width: 100,
                  child: Text(
                    "unidade",
                    style: AppTextStyles.bodyWhite20,
                  ),
                ),
                Text(
                  "nome",
                  style: AppTextStyles.bodyWhite20,
                ),
                Spacer(),
                Container(
                  width: 100,
                  child: Text(
                    "quant",
                    style: AppTextStyles.bodyWhite20,
                  ),
                ),
                Container(
                  width: 100,
                  child: Text(
                    "valor",
                    style: AppTextStyles.bodyWhite20,
                  ),
                ),
                Container(
                  width: 100,
                  child: Text(
                    "total",
                    style: AppTextStyles.bodyWhite20,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
                padding: EdgeInsets.all(10),
                child: ListView.separated(
                  itemCount: listaItens.length,
                  itemBuilder: (context, index) {
                    var item = listaItens[index];

                    var cod = item['cod'];
                    var nome = item['nome'];
                    var unidade = item['unidade'];
                    var quantidade = item['quant'];
                    var valor = item['valor'];
                    var total = item['total'];

                    return Row(
                      children: [
                        Container(width: 100, child: Text(cod)),
                        Container(width: 100, child: Text(unidade)),
                        Container(child: Text(nome)),
                        Spacer(),
                        Container(
                            width: 100, child: Text(quantidade.toString())),
                        Container(
                            width: 100,
                            child: Text('R\$ ${formatador.format(valor)}')),
                        Container(
                            width: 100,
                            child: Text('R\$ ${formatador.format(total)}')),
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      thickness: 1,
                    );
                  },
                )),
          )
        ],
      ),
    );
  }
}
