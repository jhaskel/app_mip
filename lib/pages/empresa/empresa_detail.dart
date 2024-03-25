import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mip_app/controllers/empresaController.dart';
import 'package:mip_app/controllers/usuarioController.dart';
import 'package:mip_app/global/app_text_styles.dart';
import 'package:mip_app/pages/chamados/chamado_page_detail.dart';
import 'package:mip_app/pages/empresa/edit_empresa_page.dart';
import 'package:mip_app/pages/usuarios/usuario_create_page.dart';
import 'package:mip_app/pages/usuarios/usuario_detail_page.dart';
import '../../global/app_colors.dart';

class EmpresaDetail extends StatefulWidget {
  dynamic item;

  EmpresaDetail(this.item, {super.key});

  @override
  State<EmpresaDetail> createState() => _EmpresaDetailState();
}

class _EmpresaDetailState extends State<EmpresaDetail> {
  get item => widget.item;
  final EmpresaController conEmp = Get.put(EmpresaController());

  final UsuarioController conUsu = Get.put(UsuarioController());

  @override
  void initState() {
    super.initState();
    conUsu.getUsuariosByEmpresa(context, item['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhe da Empresa"),
        actions: [
          IconButton(
              onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditEmpresaPage(item)),
                  );

              },
              icon: Icon(
                Icons.edit,
                color: AppColors.primaria,
              ))
        ],
      ),
      body: _body(),
    );
  }

  _body() {
    double largura = MediaQuery.of(context).size.width;

    return Obx(
      () => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 220,
              child: Row(
                children: [
                  Container(
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titulos('Fantasia'),
                        titulos('Nome'),
                        titulos('CNPJ'),
                        titulos('Contato'),
                        titulos('Fone'),
                        titulos('Email'),
                        titulos('Cidade'),
                        titulos('Ativo'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 220,
                      width: largura - 240,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          titulos('${item['fantasia']}'),
                          titulos('${item['nome']}'),
                          titulos('${item['cnpj']}'),
                          titulos('${item['nomeContato']}'),
                          titulos('${item['fone']}'),
                          titulos('${item['email']}'),
                          titulos('${item['cidade']}'),
                          Icon(
                            Icons.circle,
                            color: item['isAtivo'] == 1
                                ? Colors.green
                                : Colors.red,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 30,
            child: Row(
              children: [
                Text(conUsu.textPage.value),
                Spacer(),
                IconButton(
                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UsuarioCreatePage(empresa:item['id'])),
                      );
                    },
                    icon: Icon(
                      Icons.add_circle,
                      color: AppColors.primaria,
                    ))
              ],
            ),
          ),
          Container(
            height: 30,
            child: Row(
              children: [
                Container(width: 250, child: Text("nome")),
                Container(width: 200, child: Text("email")),
                Container(width: 150, child: Text("role")),
                Spacer(),
                Container(width: 100, child: Text("Ativo")),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              child: conUsu.listUsuariosByEmpresa.length > 0
                  ? ListView.separated(
                      itemCount: conUsu.listUsuariosByEmpresa.length,
                      itemBuilder: (context, index) {
                        dynamic item = conUsu.listUsuariosByEmpresa[index];
                        return InkWell(
                          onTap: () {
                             Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>UsuarioDetailPage(
                                            conUsu.listUsuariosByEmpresa[index])),
                                  );
                          },
                          child: Row(
                            children: [
                              Container(width: 250, child: Text(item['nome'])),
                              Container(width: 200, child: Text(item['email'])),
                              Container(width: 150, child: Text(item['role'])),
                              Spacer(),
                              Container(
                                  width: 100,
                                  child: item['blockStatus'] == 'no'
                                      ? Icon(
                                          Icons.circle,
                                          color: Colors.green,
                                        )
                                      : Icon(
                                          Icons.circle,
                                          color: Colors.red,
                                        )),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          thickness: 1,
                        );
                      },
                    )
                  : Center(
                      child: Text("Nenhum Usuario Encontrado"),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class titulos extends StatelessWidget {
  String texto;
  titulos(this.texto);

  @override
  Widget build(BuildContext context) {
    return Text(
      "$texto: ",
      style: AppTextStyles.bodyTitleBold,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }
}
