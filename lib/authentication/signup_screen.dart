// ignore_for_file: body_might_complete_normally_catch_error

import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mip_app/authentication/login_screeen.dart';
import 'package:mip_app/methods/common_methods.dart';
import 'package:mip_app/pages/home/dashboard.dart';
import 'package:mip_app/widgets/loading_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  TextEditingController vehicleModelController = TextEditingController();
  TextEditingController vehicleColorController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();

  CommonMethods cMethods = CommonMethods();
  XFile? imageFile;
  String urlOfUploadedImage = "";
  chooseImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              imageFile == null
                  ? const CircleAvatar(
                      radius: 86,
                      backgroundImage:
                          AssetImage("assets/images/avatarman.png"),
                    )
                  : Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                          image: DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: FileImage(
                                File(imageFile!.path),
                              ))),
                    ),
              InkWell(
                onTap: () {
                  chooseImageFromGallery();
                },
                child: const Text("Select Image",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text("Create a Driver's Account",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 22,
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(
                      controller: userNameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Your name',
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    TextField(
                      controller: passwordController,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    TextField(
                      controller: vehicleModelController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'modelo do Veículo',
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    TextField(
                      controller: vehicleColorController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Cor do Veículo',
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    TextField(
                      controller: vehicleNumberController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Placa do Veículo',
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 44,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          checkNetworkIsAvailable();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 80, vertical: 10)),
                        child: const Text('Create Account')),
                    const SizedBox(
                      height: 22,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => const LoginScreen()));
                        },
                        child: const Text(
                          'Already have an account? login here',
                          style: TextStyle(color: Colors.grey),
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void checkNetworkIsAvailable() {
    cMethods.checkConnectivity(context);

    if (imageFile != null) {
      signUpFormValidation();
    } else {
      cMethods.displaySnackBar('Please choose image first', context);
    }
  }

  signUpFormValidation() {
    if (userNameController.text.trim() == '') {
      cMethods.displaySnackBar('digite um user name', context);
    } else if (userNameController.text.trim().length < 3) {
      cMethods.displaySnackBar(
          'name precisa ser maior que 3 catachters', context);
    } else if (phoneController.text.trim().length < 8) {
      cMethods.displaySnackBar(
          'phone precisa ser maior que 8 catachters', context);
    } else if (passwordController.text.trim().length < 3) {
      cMethods.displaySnackBar(
          'senha precisa ser maior que 3 catachters', context);
    } else if (!emailController.text.trim().contains("@")) {
      cMethods.displaySnackBar('digite um email válido', context);
    } else if (vehicleModelController.text.trim().length < 3) {
      cMethods.displaySnackBar(
          'modelo doveiculo  precisa ser maior que 3 catachters', context);
    } else if (vehicleColorController.text.trim().length < 3) {
      cMethods.displaySnackBar(
          'cor do veiculo  precisa ser maior que 3 catachters', context);
    } else if (vehicleModelController.text.trim().length < 3) {
      cMethods.displaySnackBar(
          'placa do veiculo precisa ser maior que 3 catachters', context);
    } else {
      //    registerNewDriver();
      uploadImageToStorage();
    }
  }

  uploadImageToStorage() async {
    String imageIDName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceImage =
        FirebaseStorage.instance.ref().child("images").child(imageIDName);

    UploadTask uploadTask = referenceImage.putFile(File(imageFile!.path));

    TaskSnapshot snapshot = await uploadTask;

    urlOfUploadedImage = await snapshot.ref.getDownloadURL();

    setState(() {
      urlOfUploadedImage;
    });
    print("uuuuuuuuuuuu07");
    print("url $urlOfUploadedImage");
    registerNewDriver();
  }

  registerNewDriver() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: 'Registrando you account....'),
    );
    final User? userFirebase = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim())
            .catchError((e) {
      Navigator.pop(context);
      cMethods.displaySnackBar(e.toString(), context);
    }))
        .user;
    if (!context.mounted) return;
    Navigator.pop(context);

    DatabaseReference usersRef = FirebaseDatabase.instance
        .ref()
        .child('drivers')
        .child(userFirebase!.uid);

    Map driveCarInfo = {
      "carModel": vehicleModelController.text.trim(),
      "carColor": vehicleColorController.text.trim(),
      "carNUmber": vehicleNumberController.text.trim(),
    };
    Map driversDataMap = {
      "photo": urlOfUploadedImage,
      "car_details": driveCarInfo,
      "name": userNameController.text.trim(),
      "email": emailController.text.trim(),
      "phone": phoneController.text.trim(),
      "id": userFirebase.uid,
      "blockStatus": "no",
    };
    usersRef.set(driversDataMap);

    Navigator.push(context, MaterialPageRoute(builder: (c) => Dashboard()));
  }
}
