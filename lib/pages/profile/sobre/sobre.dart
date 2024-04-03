import 'package:flutter/material.dart';

class SobrePage extends StatelessWidget {
  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => SobrePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Sobre"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 25,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ILumina Braço", style: _theme.textTheme.headline5),
                const SizedBox(height: 15),
                Text(
                  'O APLICATIVO QUE VEIO PARA FACILITAR\n'
                  'É A ESCOLHA PERFEITA PARA ESQUECER SEUS CARTÕES DE FIDELIZAÇÃO FÍSICO',
                  style: _theme.textTheme.subtitle1,
                ),
                const SizedBox(height: 15),
//                 SizedBox(
//                   width: 150,
//                   height: 50,
//                   child: RaisedButton(
// //                        title: 'Learn More',
//                     onPressed: () {
//                       Get.to(WebViewExample());
//                     },
//                     child: Text('Learn more', style: _theme.textTheme.button),
//                   ),
//                 ),
                const SizedBox(height: 25),
                Text('V - 2.0.3', style: _theme.textTheme.headline2),
                Container(
                  width: 46,
                  height: 10,
                  color: _theme.primaryColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15, top: 15),
                  child: Text(

                    '2.0.3 - Correção admin',
                    style: _theme.textTheme.subtitle2,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 15, top: 15),
                  child: Text(

                    '2.0.0 - Nova versão 2024',
                    style: _theme.textTheme.subtitle2,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 15, top: 15),
                  child: Text(

                    '1.0.3 - Novo Design de telas',
                    style: _theme.textTheme.subtitle2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    '1.0.2 - Correçao de bugs',
                    style: _theme.textTheme.subtitle2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    '1.0.1 - Lançamento',
                    style: _theme.textTheme.subtitle2,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
