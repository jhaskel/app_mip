import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mip_app/controllers/cosipController.dart';
import 'package:mip_app/global/app_colors.dart';

class CreateReceitaPage extends StatelessWidget {
  const CreateReceitaPage({
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

          controller: conCos.mesController,

          decoration: InputDecoration(
            labelText: 'Mes',
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
          controller: conCos.nomeController,

          decoration: InputDecoration(
            labelText: 'Nome',
            hintText: 'arrecadado',
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
