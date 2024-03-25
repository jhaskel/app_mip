import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mip_app/controllers/empresaController.dart';
import 'package:mip_app/global/app_colors.dart';
import 'package:mip_app/global/app_text_styles.dart';

class EditEmpresaPage extends StatefulWidget {
  dynamic item;
  EditEmpresaPage(this.item, {Key? key}) : super(key: key);

  @override
  State<EditEmpresaPage> createState() => _EditEmpresaPageState();
}

class _EditEmpresaPageState extends State<EditEmpresaPage> {
  final EmpresaController conEmp = Get.put(EmpresaController());

  @override
  void initState() {

    super.initState();



    conEmp.fantasiaController.text=widget.item['fantasia'];
    conEmp.nomeController.text=widget.item['nome'];
    conEmp.cnpjController.text=widget.item['cnpj'];
    conEmp.contatoController.text=widget.item['nomeContato'];
    conEmp.foneController.text=widget.item['fone'];
    conEmp.emailController.text=widget.item['email'];
    conEmp.cidadeController.text=widget.item['cidade'];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edita Empresa"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child:  ListView(
            children: [
              TextFormField(
                focusNode: FocusNode(),
                autofocus: true,
                controller: conEmp.fantasiaController,

                decoration: InputDecoration(
                  labelText: 'Nome Fantasia',

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primaria,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                focusNode: FocusNode(),
                autofocus: true,
                controller: conEmp.nomeController,
                decoration: InputDecoration(
                  labelText: 'Razão Social',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primaria,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: conEmp.cnpjController,
                inputFormatters: [
                  MaskTextInputFormatter(
                      filter: {"##.###.###/####-##": RegExp(r'[0-9]')},
                      type: MaskAutoCompletionType.lazy)
                ],
                decoration: InputDecoration(
                  labelText: 'CNPJ',

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primaria,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: conEmp.contatoController,

                decoration: InputDecoration(
                  labelText: 'Nome do Contato',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primaria,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: conEmp.foneController,
                inputFormatters: [
                  MaskTextInputFormatter(
                      mask: '(##)#####-####',
                      filter: {"#": RegExp(r'[0-9]')},
                      type: MaskAutoCompletionType.lazy)
                ],
                decoration: InputDecoration(
                  labelText: "Fone",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primaria,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(

                controller: conEmp.emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: '-49.88789',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primaria,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              TextFormField(

                controller: conEmp.cidadeController,
                decoration: InputDecoration(
                  labelText: "Cidade/Estado",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primaria,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                color: AppColors.primaria,
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: MaterialButton(
                  onPressed: () {
                    conEmp.editEmpresa(context,widget.item['id']);
                  },
                  child: Text(
                    'Editar Empresa',
                    style: AppTextStyles.bodyWhite20,
                  ),
                ),
              ),
            ],
          ),
        ),

    );
  }
}
