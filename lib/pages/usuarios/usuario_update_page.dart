import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mip_app/controllers/usuarioController.dart';
import 'package:mip_app/global/global_var.dart';
import 'package:mip_app/global/round_button.dart';

class UsuarioUpdatePage extends StatefulWidget {

   String?  idUser;
  UsuarioUpdatePage(this.idUser);

  @override
  _UsuarioUpdatePageState createState() => _UsuarioUpdatePageState();
}

class _UsuarioUpdatePageState extends State<UsuarioUpdatePage> {

  final UsuarioController conUsu = Get.put(UsuarioController());
  @override
  void initState() {
    super.initState();
    conUsu.userNameController.text=userName;
    conUsu.phoneController.text=userFone;

    //   _con.init(context, refresh);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar perfil'),
      ),
      body: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Form(
              key: conUsu.formKey,
              child: Column(
                children: [
                  SizedBox(height: 50),
                  _textFieldName(),
                  _textFieldPhone(),
                ],
              ),
            ),
          )),
      bottomNavigationBar: _buttonUpdate(),
    );
  }



  Widget _textFieldName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),

      child:   TextFormField(
        controller: conUsu.userNameController,
        keyboardType: TextInputType.text,

        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Text is empty';
          }else if(text.length <3){
            return 'Nome precisa ter mais de 2 caracteres';
          }
          return null;
        },

        decoration: const InputDecoration(
          labelText: 'Seu Nome',
          labelStyle: TextStyle(fontSize: 14),

        ),


        style: const TextStyle(color: Colors.grey, fontSize: 15),
      ),
    );
  }

  Widget _textFieldPhone() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),

      child:   TextFormField(

        controller: conUsu.phoneController,
        inputFormatters: [
          MaskTextInputFormatter(
              mask: '(##) #####-####',
              filter: { "#": RegExp(r'[0-9]') },
              type: MaskAutoCompletionType.lazy
          ),
        ],
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Fone não pode ser vazio';
          }
          return null;
        },

        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          labelText: 'Fone',
          labelStyle: TextStyle(fontSize: 14),
        ),
        style: const TextStyle(color: Colors.grey, fontSize: 15),
      ),
    );
  }

  Widget _buttonUpdate() {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
        child: RoundButton(
          title: 'Alterar Dados',
         loading: conUsu.loading.value,
          onTap: () {
           if (conUsu.formKey.currentState!.validate()) {
              conUsu.editUsuario(context,widget.idUser);
            }
          },
        ));
  }

  void refresh() {
    setState(() {});
  }
}
