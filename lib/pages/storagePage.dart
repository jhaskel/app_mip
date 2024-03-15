
import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


/// A StatefulWidget which keeps track of the current uploaded files.
class TaskManager extends StatefulWidget {
  // ignore: public_member_api_docs
  TaskManager({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TaskManager();
  }
}

String url = "";
bool loading= false;

class _TaskManager extends State<TaskManager> {
  List<UploadTask> _uploadTasks = [];

  Future<UploadTask?> uploadFile(XFile? file) async {
    setState(() {
      loading=true;
    });
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file was selected'),
        ),
      );

      return null;
    }
String uy = DateTime.now().millisecondsSinceEpoch.toString();
    late UploadTask uploadTask;
    var mime = file.mimeType;
    var extensao = "pdf";
    print("mime $mime");
    print("000001");

    if(mime!='application/pdf'){
      Get.defaultDialog(
        title: "Ops",
        content: Text('Parece que esse arquivo não é um pdf'),
      );
      print("000002");
    }else{
      print("000003");

      // Create a Reference to the file


      Reference ref = await FirebaseStorage.instance
          .ref()
          .child('ordem-47448489')
          .child('/$uy.${extensao}');

      print("000004");
      final metadata = SettableMetadata(
        contentType: 'aplication/pdf',
        customMetadata: {'picked-file-path': file.path},
      );


        uploadTask = ref.putData(await file.readAsBytes(), metadata);


      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
        print('ok');
      });
      final progress =
          100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);

     int fgh= await taskSnapshot.bytesTransferred;
     print("fgh $progress");
     var s= await ref.getDownloadURL();
        url =s.toString();

     setState(() {
       loading=false;
     });

      Future<UploadTask?> retorno =  Future.value(uploadTask);
      if(url !=''){
        return retorno;
      }else{
        return Get.defaultDialog(title: "Ops");
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage Example App'),
        actions: [
          IconButton(onPressed: () async {
            final file = await ImagePicker().pickImage(source: ImageSource.gallery);

            UploadTask? task = await uploadFile(file);
            print("task $task");

            if (task != null) {
              print("fez");
              setState(() {
                _uploadTasks = [..._uploadTasks, task];              });

            }else{
              Get.defaultDialog(title: "Não foi possivel",content: Text("Tente novamente"));
            }


          }, icon: Icon(Icons.browse_gallery)),
          IconButton(onPressed: (){}, icon: Icon(Icons.add))

        ],
      ),
      body: url==""
          ? loading?Center(child: CircularProgressIndicator()): Center(child: Text("Press the '+' button to add a new file."))
          :
           Column(children: [
            InkWell(
              onTap: () async{

              }, child: Text("$url")),

          ],


          ),



    );
  }
}

