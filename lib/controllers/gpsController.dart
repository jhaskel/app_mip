

import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class GpsConstroller extends GetxController{

  final text = 'jsjsj'.obs;
   final  isGpsEnabled = false.obs;
  final  isGpsPermissionGranted=false.obs;
  final  isAllPermissionGranted=false.obs;


  // Status of a permission request to use location services
  late PermissionStatus permissionGranted;



   StreamSubscription? gpsServiceSubscription;

   Future<void> init() async {

   _isPermissionGranted();

     final gpsInitStatus = await Future.wait([_checkGpsStatus()]);

     isGpsEnabled(gpsInitStatus[0]);
     isGpsPermissionGranted(gpsInitStatus[1]);
   }

   Future<bool> _checkGpsStatus() async {
     print("haskel");

     final isEnable= await Geolocator.isLocationServiceEnabled();
     print("isEnable $isEnable");
     gpsServiceSubscription= Geolocator.getServiceStatusStream().listen((event){
       print('serviceX${event.index}');
       final isEnabled = (event.index==1)?true:false;
       isGpsEnabled(isEnabled);
       isGpsPermissionGranted(isGpsPermissionGranted.value);
       if(isGpsEnabled==true && isGpsPermissionGranted==true){
         isAllPermissionGranted(true);
       }else{
         isAllPermissionGranted(false);
       }



     });
update();
     return isEnable;
   }

  Future<bool> _isPermissionGranted() async{
    final isGranted = await Permission.location.isGranted;

    print("isgrantedX $isGranted");
    isGpsPermissionGranted(isGranted);
    return isGranted;
  }



  Future<Position> _posicaoAtual() async {
    print('0000');
    LocationPermission permissao;
    bool ativado = await Geolocator.isLocationServiceEnabled();
    print("ativado $ativado");


    if (!ativado) {
      print('0001');

      return Future.error('Por favor, habilite a localização no smartphone.');
    }

    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      print('00002');
      permissao = await Geolocator.requestPermission();

      if (permissao == LocationPermission.denied) {
        print('0003');
        _posicaoAtual();
        return Future.error('Você precisa autorizar o acesso à localização.');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      return Future.error('Autorize o acesso à localização nas configurações.');
    }
    isGpsEnabled(true);
    print("habilitado");
    //return await Geolocator.getCurrentPosition().then((value) => buscaPostes());

    // buscaPostes();
    update();
    return await Geolocator.getCurrentPosition();
  }

  Future<void> askGpsAccess()async{



    final status = await Permission.location.request();

    print("status $status");

    switch(status){

      case PermissionStatus.granted:

        isGpsPermissionGranted(true);
        _posicaoAtual();

      case PermissionStatus.denied:

      case PermissionStatus.restricted:

      case PermissionStatus.limited:

      case PermissionStatus.permanentlyDenied:

      case PermissionStatus.provisional:
      isGpsEnabled(false);
      isGpsPermissionGranted(false);

      //  openAppSettings();

    }
  }


  @override
    close() {
    gpsServiceSubscription?.cancel();
    return super.onClose();
  }


}