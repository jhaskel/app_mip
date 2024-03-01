import 'package:flutter/material.dart';
import 'package:mip_app/global/app_text_styles.dart';
import 'package:mip_app/pages/ordem/create_ordem_Itens.dart';
import 'package:mip_app/pages/ordem/create_ordem_servicos.dart';

class CreateOrdemHome extends StatefulWidget {
  @override
  State<CreateOrdemHome> createState() => _CreateOrdemHomeState();
}

class _CreateOrdemHomeState extends State<CreateOrdemHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentPosition = 0;

  final _pages = [
    CreateOrdemItens(),
    CreateOrdemServicos(),
  ];

  @override
  void initState() {
    _tabController = TabController(length: _pages.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Gerar Ordens'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 1200,
              child: TabBar(
                padding: EdgeInsets.only(bottom: 10),
                indicatorWeight: 4,
                controller: _tabController,
                labelColor: Colors.amber,
                unselectedLabelColor: Colors.white60,
                labelStyle: AppTextStyles.heading15,
                tabs: const [
                  Tab(
                    text: "Ordem Itens",
                  ),
                  Tab(
                    text: "Ordem de Serviços",
                  ),
                ],
                onTap: (position) {
                  setState(() {
                    _currentPosition = position;
                  });
                },
              ),
            ),
            Expanded(child: buildPage()),
          ],
        ));
  }

  Widget buildPage() => _pages[_currentPosition];

  modalBottomSheet(
    context,
  ) {}
}
