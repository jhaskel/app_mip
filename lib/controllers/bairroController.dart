import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class BairroController extends GetxController {
  var bairros = Map<String, String>().obs;
  List<dynamic> listaBairros = [].obs;
  var bairroAtivo ="".obs;

  var ruas = Map<String, String>().obs;
  List<dynamic> listaRuas = [].obs;

  final ref = FirebaseDatabase.instance.ref('Bairro');

  getBairros() async {
    await ref.get().then((value) {
      Map pos = value.value as Map;

      listaBairros.clear();


      listaBairros = pos.values.toList()

        ..sort(((a, b) => (a["nome"]).compareTo((b["nome"]))));
      print('bairros $listaBairros');


      for (var x in listaBairros) {

          bairros.addAll({x['id']: x['nome']});



      }
      print("Bbbb $bairros");
      print("ruas $ruas");
    });
    update();
  }

  getRuas() async {
    listaRuas.clear();
    print("jjj09 ${listaBairros}");

    for (var x in listaBairros) {

      if(x['nome']==bairroAtivo.value){
        Map pos = x['Logradouro'] as Map;
        listaRuas = pos.values.toList();


      }

    }
    print("lista ruas $listaRuas");
    for(var y in listaRuas){
      print("YYYYYYYY ${y['nome']}");
      ruas.addAll({y['id']: y['nome']});

    }
    print("jjj $ruas");





    update();
  }

}
