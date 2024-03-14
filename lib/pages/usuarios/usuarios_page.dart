import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/authentication/signup_screen.dart';
import 'package:mip_app/controllers/usuarioController.dart';
import 'package:mip_app/global/app_colors.dart';
import 'package:mip_app/pages/usuarios/usuario_create_page.dart';

class UsuarioPage extends StatefulWidget {
  const UsuarioPage({Key? key}) : super(key: key);

  @override
  State<UsuarioPage> createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  final UsuarioController conUsu = Get.put(UsuarioController());

  @override
  void initState() {
    super.initState();
    conUsu.getUsuarios(context);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(conUsu.textPage.value),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UsuarioCreatePage()),
                  );
                },
                icon: Icon(
                  Icons.add_circle_sharp,
                  color: AppColors.primaria,
                ))
          ],
        ),
        body: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          width: 2, color: AppColors.borderCabecalho),
                      bottom: BorderSide(
                          width: 2, color: AppColors.borderCabecalho))),
              width: MediaQuery.of(context).size.width,
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
                child: conUsu.listUsuarios.length > 0
                    ? ListView.separated(
                        itemCount: conUsu.listUsuarios.length,
                        itemBuilder: (context, index) {
                          dynamic item = conUsu.listUsuarios[index];
                          return InkWell(
                            onTap: () {
                              /* Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>UsuarioDetail(
                                        conUsu.listUsuarios[index])),
                              );*/
                            },
                            child: Row(
                              children: [
                                Container(
                                    width: 250, child: Text(item['nome'])),
                                Container(
                                    width: 200, child: Text(item['email'])),
                                Container(
                                    width: 150, child: Text(item['role'])),
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
      ),
    );
  }


}
