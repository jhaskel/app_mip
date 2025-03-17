import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mip_app/controllers/gpsController.dart';

class GpsAccessScreen extends StatefulWidget {
  const GpsAccessScreen({super.key});

  @override
  State<GpsAccessScreen> createState() => _GpsAccessScreenState();
}

class _GpsAccessScreenState extends State<GpsAccessScreen> {

  final controller = Get.put(GpsConstroller());

  @override
  void initState() {
   controller.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Obx(
        ()=> Scaffold(
          appBar: AppBar(title: Text('${controller.text.value}'),),

            body: Center(child:  controller.isGpsEnabled==false
              ?const _EnableGpsMessage()
              :const _AcessButton()

      )

          //  _AcessButton())

          ),
    );
  }
}

class _AcessButton extends StatelessWidget {
  const _AcessButton({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('É necessário acesso ao gps'),
        MaterialButton(
          color: Colors.black,
          elevation: 0,
          shape: StadiumBorder(),
          splashColor: Colors.transparent,
          onPressed: () {

         /*   final gpsBloc= BlocProvider.of<GpsBloc>(context);
            gpsBloc.askGpsAccess();*/
          },
          child: Text(
            "Acesso ao Gps",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}

class _EnableGpsMessage extends StatelessWidget {
  const _EnableGpsMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return  Center(
      child:  Text(
          'Deve habilitar o gps',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
        ),

    );
  }
}
