import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class CommonMethods {

  checkConnectivity(BuildContext context)async{
    var connectionResult = await Connectivity().checkConnectivity();
    print("internet ${connectionResult.first}");
    if(connectionResult.first != ConnectivityResult.mobile || connectionResult.first != ConnectivityResult.wifi){
print("00009x");
if(!context.mounted) return;
       displaySnackBar('Você está sem internet!', context);
    }else{
      print("00009xy");

    }


  }
  displaySnackBar(String messageText,BuildContext context){
    var snackBar = SnackBar(content: Text(messageText));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}