import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mip_app/controllers/bairroController.dart';
import 'package:mip_app/controllers/ipController.dart';
import 'package:mip_app/global/app_colors.dart';
import 'package:mip_app/global/app_text_styles.dart';

class CreateIpPage extends StatefulWidget {
   CreateIpPage({
    super.key,
    required this.conIp,
  });

  final IpController conIp;


  @override
  State<CreateIpPage> createState() => _CreateIpPageState();
}

class _CreateIpPageState extends State<CreateIpPage> {
  final BairroController conBai = Get.put(BairroController());

  @override
  void initState() {

    super.initState();
    conBai.getBairros();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Novo IP"),),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Obx(
          ()=> ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownSearch<String>(
                  selectedItem: 'Selecione um Bairro',
                  items: conBai.bairros.values.toList(),
                  onChanged: (v) async {
                    var id = conBai.bairros.keys.firstWhere(
                            (k) => conBai.bairros[k] == v,
                        orElse: () => "null");

               //     conCha.idIp.value = id;
                    conBai.bairroAtivo.value=v!;
                    widget.conIp.bairro.value = v!;
                    print("ggggg ${conBai.bairroAtivo.value}");
                    conBai.getRuas();



                 //   await conCha.getIpUnico(conCha.idIp.value);
                  },
                  popupProps: const PopupPropsMultiSelection.menu(
                    isFilterOnline: false,
                    showSelectedItems: true,
                    showSearchBox: true,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownSearch<String>(
                  selectedItem: 'Selecione um Logradouro',
                  items: conBai.ruas.values.toList(),
                  onChanged: (v) async {
                    var id = conBai.bairros.keys.firstWhere(
                            (k) => conBai.bairros[k] == v,
                        orElse: () => "null");



                    widget.conIp.logradouro.value = v!;




                    //   await conCha.getIpUnico(conCha.idIp.value);
                  },
                  popupProps: const PopupPropsMultiSelection.menu(
                    isFilterOnline: false,
                    showSelectedItems: true,
                    showSearchBox: true,
                  ),
                ),
              ),
              SizedBox(height: 15,),
              TextFormField(
                focusNode: FocusNode(),
                autofocus: true,
                controller: widget.conIp.codController,
                inputFormatters: [
                  MaskTextInputFormatter(
                      mask: 'AD ####',
                      filter: { "#": RegExp(r'[0-9]') },
                      type: MaskAutoCompletionType.lazy
                  )],
                decoration: InputDecoration(
                  labelText: 'Codigo Luminária',
                  hintText: 'AD678...',
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
                focusNode: FocusNode(),
                autofocus: true,
                controller: widget.conIp.tipoController,
                decoration: InputDecoration(
                  labelText: 'Tipo Lâmpada',
                  hintText: 'led, vapor de sódio....',
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
                controller: widget.conIp.potenciaController,
                inputFormatters: [
                  MaskTextInputFormatter(

                      filter: { "#": RegExp(r'[0-9]') },
                      type: MaskAutoCompletionType.lazy
                  )],
                decoration: InputDecoration(
                  labelText: 'Potencia Lâmpada',
                  hintText: '70,100,150....',
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
                controller: widget.conIp.alturaController,
                inputFormatters: [
                  MaskTextInputFormatter(

                      filter: { "#": RegExp(r'[0-9]') },
                      type: MaskAutoCompletionType.lazy
                  )],

                decoration: InputDecoration(
                  labelText: 'Altura poste',
                  hintText: '8.0,9.0....',
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
                controller: widget.conIp.latController,
                inputFormatters: [
                  MaskTextInputFormatter(
                      mask: '-27.######',
                      filter: { "#": RegExp(r'[0-9]') },
                      type: MaskAutoCompletionType.lazy
                  )],

                decoration: InputDecoration(
                  labelText: "Latitude",
                  hintText: '-27.877666',


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
                  inputFormatters: [
                  MaskTextInputFormatter(
                  mask: '-49.######',
                  filter: { "#": RegExp(r'[0-9]') },
                  type: MaskAutoCompletionType.lazy
              )],
                controller: widget.conIp.longController,

                decoration: InputDecoration(
                  labelText: "Longitude",
                  hintText: '-49.88789',


                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primaria,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),

                ),
              ),
              SizedBox(height: 25,),
              Container(
                color: AppColors.primaria,
                height: 50,
                width: MediaQuery.of(context).size.width,

                child: MaterialButton(

                    onPressed: (){
                      widget.conIp.createdIp(context);

                    },child: Text('Adicionar Ip',style: AppTextStyles.bodyWhite20,),

                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
