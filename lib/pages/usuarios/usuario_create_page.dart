
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/usuarioController.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mip_app/global/global_var.dart';
import 'package:mip_app/global/util.dart';
import 'package:toggle_switch/toggle_switch.dart';


class UsuarioCreatePage extends StatefulWidget {
  String? empresa;
   UsuarioCreatePage({this.empresa,Key? key}) : super(key: key);

  @override
  State<UsuarioCreatePage> createState() => _UsuarioCreatePageState();
}

class _UsuarioCreatePageState extends State<UsuarioCreatePage> {

  final UsuarioController conUsu = Get.put(UsuarioController());

  List <String>listRoleSupervisor = [Util.roles[1],Util.roles[2]];
  List <String>listRoleAdmin = [Util.roles[0],Util.roles[1],Util.roles[2],Util.roles[3]];
  List <String>listRoleDev = [Util.roles[0],Util.roles[1],Util.roles[2],Util.roles[3],Util.roles[4]];
  String idEmpresa = '';
 @override
  void initState() {

   if(widget.empresa!=null){
     idEmpresa = widget.empresa!;
   }

    super.initState();
    if(userRole=='supervisor'){
      conUsu.role('operador');
    }else{
      conUsu.role('user');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(listRoleDev[0]);
    print(userRole);
    print(userName);
    return Scaffold(
      appBar: AppBar(title: Text("Criar Nova conta"),),
      body: Obx(
          ()=> SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),

                 Text(conUsu.textPageCreate.value,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 22,
                ),

                Container(height: 120,child: ToggleSwitch(
                  minWidth: 90.0,
                  minHeight: 90.0,
                  fontSize: 16.0,
                  initialLabelIndex: 0,
                  activeBgColor: [Colors.green],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.grey[900],
                  totalSwitches: defineQant(userRole),
                  labels: defineList(userRole),
                  onToggle: (index) {


                    print('switched to: $index');

                  defineRetorno(index,userRole);


                  },
                ),),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      TextField(

                        controller: conUsu.userNameController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Seu Nome',
                          labelStyle: TextStyle(fontSize: 14),
                        ),
                        style: const TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      TextField(

                        controller: conUsu.phoneController,
                        inputFormatters: [
                          MaskTextInputFormatter(
                              mask: '(##) #####-####',
                              filter: { "#": RegExp(r'[0-9]') },
                              type: MaskAutoCompletionType.lazy
                          ),
                        ],
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Fone',
                          labelStyle: TextStyle(fontSize: 14),
                        ),
                        style: const TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      TextField(
                        controller: conUsu.emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(fontSize: 14),
                        ),
                        style: const TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      TextField(
                        controller: conUsu.passwordController,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(fontSize: 14),
                        ),
                        style: const TextStyle(color: Colors.grey, fontSize: 15),
                      ),

                      const SizedBox(
                        height: 44,
                      ),
                      ElevatedButton(
                          onPressed: () {

                           conUsu.checkNetworkIsAvailable(context,empresa: idEmpresa);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 80, vertical: 10)),
                          child: const Text('Nova Conta')),


                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  defineQant(String role) {
    print("TRRRR $role");
    if (role==Util.roles[2]){
      return 2;
    }else if(role==Util.roles[3]){
      return 4;
    }else{
      return 5;
    }
  }

  defineList(String role) {

    if (role==Util.roles[2]){
      return listRoleSupervisor;
    }else if(role==Util.roles[3]){
      return listRoleAdmin;
    }else{
      return listRoleDev;
    }


  }

  void defineRetorno(int? index,String role) {
    if (role==Util.roles[2]){
       conUsu.role(listRoleSupervisor[index!]);
    }else if(role==Util.roles[3]){
        conUsu.role(listRoleAdmin[index!]);
    }else{

        conUsu.role(listRoleDev[index!]);



    }

  }




}
