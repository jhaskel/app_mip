import 'package:get/get.dart';

class HomeMainController extends GetxController {
  final raio = 0.0.obs;
  static HomeMainController get to => Get.find<HomeMainController>();
  String get distancia => raio.value < 1
      ? '${(raio.value * 1000).toStringAsFixed(0)} m'
      : '${(raio.value).toStringAsFixed(1)} km';
}
