
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mip_app/global/round_button.dart';

import 'package:mip_app/methods/common_methods.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);
  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => ForgotPasswordScreen(),
    );
  }

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  CommonMethods cMethods = CommonMethods();
  bool enviando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alterar a senha?'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(hintText: 'Email'),
            ),
            SizedBox(
              height: 40,
            ),
            enviando?CircularProgressIndicator():RoundButton(
                title: 'Enviar',
                onTap: () async {
                  setState(() {
                    enviando=true;
                  });
              var envio =    await  auth
                      .sendPasswordResetEmail(
                          email: emailController.text.toString())
                      .then((value) {
                    cMethods.displaySnackBar("Enviamos um e-mail para você recuperar a senha, verifique seu e-mail", context);

                  }).onError((error, stackTrace) {

                    cMethods.displaySnackBar("Email não cadastrado", context);



                  });
                  setState(() {
                    enviando=false;
                  });
                })
          ],
        ),
      ),
    );
  }
}
