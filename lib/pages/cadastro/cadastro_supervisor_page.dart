import 'package:flutter/material.dart';
import 'package:mip_app/pages/Cosip/cosip_page.dart';
import 'package:mip_app/pages/Prefeitura/prefeitura_page.dart';
import 'package:mip_app/pages/chamados/chamados_page.dart';
import 'package:mip_app/pages/empresa/empresa_page.dart';
import 'package:mip_app/pages/ip/ip_page.dart';
import 'package:mip_app/pages/licitacao/licitacao_page.dart';
import 'package:mip_app/pages/ordem/ordem_page.dart';
import 'package:mip_app/pages/usuarios/usuarios_page.dart';

import 'package:side_navigation/side_navigation.dart';


class CadastroSupervisorPage extends StatefulWidget {
  const CadastroSupervisorPage({Key? key}) : super(key: key);

  @override
  _CadastroSupervisorPageState createState() => _CadastroSupervisorPageState();
}

class _CadastroSupervisorPageState extends State<CadastroSupervisorPage> {
  List<Widget> views = const [

    ChamadosPage(),
    OrdemPage(),
    LicitacaoPage(),
    EmpresaPage(),



  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideNavigationBar(
            header: SideNavigationBarHeader(
                image: CircleAvatar(
                  child: Icon(Icons.account_balance),
                ),
                title: Text('Cadastros'),
                subtitle: Text('')
            ),

            selectedIndex: selectedIndex,
            items: const [

              SideNavigationBarItem(
                icon: Icons.perm_contact_cal_rounded,
                label: 'Chamados',
              ),
              SideNavigationBarItem(
                icon: Icons.featured_play_list_rounded,
                label: 'Ordens',
              ),
              SideNavigationBarItem(
                icon: Icons.import_contacts,
                label: 'Licitação',
              ),

              SideNavigationBarItem(
                icon: Icons.house_outlined,
                label: 'Empresa',
              ),

            ],
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: views.elementAt(selectedIndex),
          )
        ],
      ),
    );
  }
}