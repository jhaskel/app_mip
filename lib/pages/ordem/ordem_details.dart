import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mip_app/controllers/chamadoController.dart';
import 'package:mip_app/controllers/cosipController.dart';
import 'package:mip_app/controllers/empresaController.dart';
import 'package:mip_app/controllers/itemController.dart';
import 'package:mip_app/controllers/licitacaoController.dart';
import 'package:mip_app/controllers/ordemController.dart';
import 'package:mip_app/controllers/prefeituraController.dart';
import 'package:mip_app/global/app_colors.dart';
import 'package:mip_app/global/app_text_styles.dart';
import 'package:mip_app/global/global_var.dart';
import 'package:mip_app/global/util.dart';
import 'package:mip_app/pages/ordem/pdf/oficio_pdf.dart';
import 'package:mip_app/pages/ordem/pdf/pdf-ordem-empresa.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final CosipController conCos = Get.put(CosipController());

  var formatador = NumberFormat("#,##0.00", "pt_BR");
  TextEditingController numero = TextEditingController();

  List<dynamic> listaItens = [].obs;
  List<Map<String, dynamic>> list = [];
  get item => widget.item;
  String licitacao = '';
  String empresa = '';
  String tipo = '1';
  String urlSf = "";
  String urlNf = "";
  bool loading = false;
  List<UploadTask> _uploadTasks = [];

  lici(String id) async {
    await conLic.getLicitacaoById(context, id);
    licitacao = (conLic.licitacao['processo']);
  }

  empre(String id) async {
    await conEmp.getEmpresa(context, id);
    empresa = (conLic.licitacao['empresa']);
  }

  Future<UploadTask?> uploadFile(XFile? file, String tipoFile) async {
    setState(() {
      loading = true;
    });
    if (file == null) {
      print("abaixo");
      print(conCos.listaDotacoes);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nenhum arquivo Selecionado!'),
        ),
      );

      return null;
    }
    String uy = DateTime.now().millisecondsSinceEpoch.toString();
    late UploadTask uploadTask;
    var mime = file.mimeType;
    var extensao = "pdf";
    print("mime $mime");

    if (mime != 'application/pdf') {
      Get.defaultDialog(
        title: "Ops",
        content: Text('Parece que esse arquivo não é um pdf'),
      );

      setState(() {
        loading = false;
      });
    } else {
      // Create a Reference to the file

      Reference ref = await FirebaseStorage.instance
          .ref()
          .child('ordens/')
          .child('${item['id']}')
          .child('/$tipoFile-$uy.${extensao}');

      final metadata = SettableMetadata(
        contentType: 'aplication/pdf',
        customMetadata: {'picked-file-path': file.path},
      );

      uploadTask = ref.putData(await file.readAsBytes(), metadata);

      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
        print('ok');
      });
      final progress =
          100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);

      int fgh = await taskSnapshot.bytesTransferred;
      print("fgh $progress");
      var s = await ref.getDownloadURL();

      setState(() {
        if (tipoFile == 'sf') {
          urlSf = s.toString();
        } else {
          print("aquilll");
          urlNf = s.toString();
        }

        loading = false;
      });

      Future<UploadTask?> retorno = Future.value(uploadTask);
      if (urlSf != '') {
        setState(() {
          loading = false;
        });

        return retorno;
      } else if (urlNf != '') {
        setState(() {
          loading = false;
        });

        return retorno;
      } else {
        setState(() {
          loading = false;
        });

        return Get.defaultDialog(title: "Ops");
      }
    }
  }
bool confirmado = true;
  @override
  void initState() {
    super.initState();
    conOrd.ordemConfirmada.value= item['isConfirmada'];
    print(("mes ${DateTime.now().month}"));
    conPref.getPrefeitura(context);
    conIte.getItensByChamadoPdf(item['cod']);


    lici(item['itensOrdem'][0]['licitacao']);
    empre(item['itensOrdem'][0]['empresa']);

    tipo = item['id'][item['id'].length - 1];
    print("tipo $tipo");
    conCos.getDotacaoByAnoByTipo(DateTime.now().year.toString(),tipo);

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

  Future<void> launch(String url, {bool isNewTab = true}) async {
    await launchUrl(
      Uri.parse(url),
      webOnlyWindowName: isNewTab ? '_blank' : '_self',
    );
  }


  @override
  Widget build(BuildContext context) {

    return Obx(()=>
       Scaffold(
        bottomNavigationBar:

       conOrd.ordemConfirmada.value==false&&confirmado==true?Container(
          height: 50,
          color: Colors.amber,
          child: InkWell(
              onTap: () {
                conOrd.alterarStatus(
                    context, StatusApp.ordemConfirmada.message,widget.item);
                setState(() {
                  confirmado=false;
                });
              },
              child: Center(
                  child: Text(
                    "Confirmar Ordem",
                    style: AppTextStyles.body20,
                  ))),
        ): Container(
         height: 50,
         color: Colors.grey,
         child: InkWell(
             onTap: () {

             },
             child: Center(
                 child: Text(
                   "Ordem Confirmada",
                   style: AppTextStyles.body20,
                 ))),
       ),


        appBar: AppBar(
          title: Text('Detalhe da Ordem ${item['cod']}'),
          actions: [
            IconButton(
                onPressed: () {
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
                        keyboardType: TextInputType.number,
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
            Container(
              padding: EdgeInsets.all(10),
              height: 220,
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
                    Tooltip(
                      message: "Visualizar",
                      child: Container(
                          child: item['urlSf'] == "" && urlSf == ""
                              ? ElevatedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                              side: BorderSide(
                                                  color: Colors.red)))),
                                  onPressed: () async {

                                    var despesa = {
                                      "dotacao": conCos.codDotacao.value,
                                      "id":DateTime.now().millisecondsSinceEpoch.toString(),
                                      "mes":Util.meses[DateTime.now().month],
                                      "nome":"manutenção",
                                      "valor":item['valor']
                                    };


                                    final file = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);

                                    UploadTask? task =
                                        await uploadFile(file, 'sf');

                                    if (task != null) {
                                      conCos.createdDespesa(context,despesa);

                                      setState(() {
                                        _uploadTasks = [..._uploadTasks, task];
                                      });
                                      if (urlSf != "") {
                                        conOrd.alteraStatusUrl(
                                            item['id'], urlSf, "sf");
                                      }
                                      print("iuios");
                                    }


                                  },
                                  child: Text("Enviar"),
                                )
                              : IconButton(
                                  onPressed: () {
                                    urlSf != ""
                                        ? launch(urlSf, isNewTab: true)
                                        : launch(item['urlSf'], isNewTab: true);
                                  },
                                  icon: Icon(Icons.picture_as_pdf))),
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
                    item['urlSf'] != ""
                        ? Container(
                            child: Tooltip(
                                message: 'Visualizar',
                                child: Container(
                                    child: item['urlNf'] == "" && urlNf == ""
                                        ? ElevatedButton(
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                18.0),
                                                        side: BorderSide(
                                                            color: Colors.red)))),
                                            onPressed: () async {
                                              final file = await ImagePicker()
                                                  .pickImage(
                                                      source:
                                                          ImageSource.gallery);

                                              UploadTask? task =
                                                  await uploadFile(file, 'nf');

                                              if (task != null) {
                                                setState(() {
                                                  _uploadTasks = [
                                                    ..._uploadTasks,
                                                    task
                                                  ];
                                                });
                                                if (urlNf != "") {
                                                  conOrd.alteraStatusUrl(
                                                      item['id'], urlNf, "nf");
                                                }
                                              }
                                            },
                                            child: Text("Enviar"),
                                          )
                                        : IconButton(
                                            onPressed: () {
                                              urlNf != ""
                                                  ? launch(urlNf, isNewTab: true)
                                                  : launch(item['urlNf'],
                                                      isNewTab: true);
                                            },
                                            icon: Icon(Icons.picture_as_pdf)))),
                          )
                        : Text(""),
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
                            setState(() {

                            });
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
      ),
    );
  }
}
