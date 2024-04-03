import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/authentication/fogot_password.dart';
import 'package:mip_app/authentication/login_screeen.dart';
import 'package:mip_app/controllers/loginControllers.dart';
import 'package:mip_app/controllers/usuarioController.dart';
import 'package:mip_app/global/app_colors.dart';
import 'package:mip_app/global/global_var.dart';
import 'package:mip_app/pages/profile/privacidade/privacidade.dart';
import 'package:mip_app/pages/profile/sobre/sobre.dart';
import 'package:mip_app/pages/usuarios/usuario_update_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final UsuarioController conUsu = Get.put(UsuarioController());
  final LoginController conLog = Get.put(LoginController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meu Perfil',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          userName!=""? IconButton(
                    onPressed: () {
                     Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UsuarioUpdatePage(userId)),
                      );
                    },
                    icon: Icon(
                      Icons.settings,
                      color: AppColors.primaria,
                    ),


          ):Container()
        ],
      ),
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    return userId!=""?StreamBuilder(
        stream: conUsu.ref.child(userId).onValue,
      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }else{
          dynamic item = snapshot.data?.snapshot.value;
          print("item $item");
          return SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: 500,
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                        const AssetImage('assets/images/user_profile.png'),
                        radius: 50,
                        backgroundColor: Colors.grey[200],
                      ),
                      title: Text(item['nome']),
                      subtitle: Text(item['role']),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(width:40,child: Icon(Icons.alternate_email)),
                              Container(width: 100,child: Text("email"),),
                              Container(child: Text(item['email']),),
                            ],
                          ),
                          Row(
                            children: [
                              Container(width:40,child: Icon(Icons.phone_android)),
                              Container(width: 100,child: Text("Fone"),),
                              Container(child: Text(item['fone']),),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(),
                    ),
                    listLinks(Icons.password, 'Alterar Senha', () {}),
                    listLinks(Icons.announcement_outlined, 'Privacidade', () {}),
                    listLinks(Icons.info_outline, 'Sobre', () {}),
                    listLinks(Icons.star_border, 'Avaliar esse app', () {}),
                    listLinks(Icons.power_settings_new, 'Sair', () {}),
                  ],
                ),
              ),
            ),
          );

        }

      }
    ):SingleChildScrollView(
      child: Center(
        child: SizedBox(
          width: 500,
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                  const AssetImage('assets/images/user_profile.png'),
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                ),
                title: Text("Anônimo"),
                subtitle: (Text("Usuário")),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(),
              ),

              listLinks(Icons.announcement_outlined, 'Privacidade', () {}),
              listLinks(Icons.info_outline, 'Sobre', () {}),
              listLinks(Icons.star_border, 'Avaliar esse app', () {}),
               listLinks(Icons.power_settings_new, 'Logar', () {})

            ],
          ),
        ),
      ),
    );
  }

  listLinks(IconData icon, String title, void Function() navegar) {
    return InkWell(
      onTap: () {
        if (title == 'Alterar Senha') {
          Navigator.of(context).push(ForgotPasswordScreen.route());
        }
        if (title == 'Privacidade') {
          Navigator.of(context).push(PrivacidadePage.route());
        }
        if (title == 'Sobre') {
          Navigator.of(context).push(SobrePage.route());
        }
        if (title == 'Avaliar esse app') {
          Navigator.of(context).push(SobrePage.route());
        }
        if (title == 'Sair') {
          conLog.logout(context);
        }
        if (title == 'Logar') {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => false);
        }
      },
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon),
            title: Text(title),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(thickness: 1.2),
        ],
      ),
    );
  }
}
