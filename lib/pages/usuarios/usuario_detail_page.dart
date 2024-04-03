import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/usuarioController.dart';
import 'package:mip_app/global/app_colors.dart';
import 'package:mip_app/pages/usuarios/usuario_update_page.dart';

class UsuarioDetailPage extends StatefulWidget {
  dynamic user;
  String? idUser;

  UsuarioDetailPage(this.user, {this.idUser,Key? key}) : super(key: key);

  @override
  State<UsuarioDetailPage> createState() => _UsuarioDetailPageState();
}

class _UsuarioDetailPageState extends State<UsuarioDetailPage> {
  @override
  final UsuarioController conUsu = Get.put(UsuarioController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Detalhe do Usuário"),
          actions: [IconButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UsuarioUpdatePage(widget.user['id'])),
            );
          }, icon: Icon(Icons.edit,color: AppColors.primaria,))],
        ),
        body: _body());
  }

  _body() => StreamBuilder(
      stream: conUsu.ref.child(widget.user['id']).onValue,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          dynamic item = snapshot.data?.snapshot.value;
          return Obx(
            ()=> Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(width: conUsu.halCon.value, child: Text('Nome: ')),
                      Text(item['nome']),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(width: 150, child: Text('Email: ')),
                      Text(item['email']),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(width: 150, child: Text('Celular: ')),
                      Text(item['fone']),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(width: 150, child: Text('Permissão: ')),
                      InkWell(
                        onTap: (){
                          Get.defaultDialog(title: "Opps",content: Text("Não é possivel alterar a permissão"));

                        },

                          child: Text(item['role'])),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(width: 150, child: Text('Status: ')),
                      InkWell(
                        onTap: (){
                          if(conUsu.status.value=="no"){
                            conUsu.status("si");
                          }else{
                            conUsu.status("no");
                          }
                          conUsu.editUsuarioStatus(context, item['id']);

                        },
                        child: defineStatus(item['blockStatus']),
                      )

                    ],
                  ),
                ),
              ],
            ),
          );
        }
      });

  defineStatus(String item) {
    if(item=='no'){
      return Icon(Icons.circle,color: Colors.green,);
    }else{
      return Icon(Icons.circle,color: Colors.red,);
    }


  }
}
