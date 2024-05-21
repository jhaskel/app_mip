import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class BairroController extends GetxController {
  var bairros = Map<String, String>().obs;
  var ruas = Map<String, String>().obs;
  List<dynamic> listaBairros = [].obs;
  List<dynamic> listaRuas = [].obs;
  var bairroAtivo ="".obs;
  var bairroAtivoId ="".obs;
  var ruaAtivoId ="".obs;
  var ruaAtivo ="".obs;




  final ref = FirebaseDatabase.instance.ref('Bairro');
  final refRua = FirebaseDatabase.instance.ref('Logradouro');

  getBairros() async {
    await ref.get().then((value) {
      Map pos = value.value as Map;
      listaBairros.clear();
      listaBairros = pos.values.toList();
      for (var x in listaBairros) {
        bairros.addAll({x['id']: x['nome']});
      }

    });

    update();
  }

  getRuas() async {
    listaRuas.clear();

    ruas.clear();
    await refRua.orderByChild('bairro').equalTo(bairroAtivo.value).get().then((value) {
      Map pos = value.value as Map;

      listaRuas = pos.values.toList();
      for (var x in listaRuas) {
        ruas.addAll({x['id']: x['nome']});
      }


    });
    update();

  }

}
