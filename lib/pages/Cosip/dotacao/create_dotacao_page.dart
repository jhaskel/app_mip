import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/cosipController.dart';
import 'package:mip_app/global/app_colors.dart';

class CreateDotacaoPage extends StatelessWidget {
  const CreateDotacaoPage({
    super.key,
    required this.conCos,
  });

  final CosipController conCos;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [


        TextFormField(
          focusNode: FocusNode(),
          autofocus: true,


          controller: conCos.codController,

          decoration: InputDecoration(
            labelText: 'Código',
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.primaria,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),

          ),
        ),
        SizedBox(height: 15,),
        TextFormField(
          controller: conCos.tipoController,

          decoration: InputDecoration(
            labelText: 'Tipo',
            hintText: '1,2 ou 3',
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.primaria,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),

          ),
        ),
        SizedBox(height: 15,),
        TextFormField(
          controller: conCos.valorController,

          decoration: InputDecoration(
            labelText: 'Valor',
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.primaria,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),

          ),
        ),
      ],
    );
  }
}
