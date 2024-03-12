import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/loginControllers.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final LoginController conLog = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: InkWell(
          onTap: (){
            conLog.logout(context);

          },

          child: Text('Profile')),
    );
  }
}
