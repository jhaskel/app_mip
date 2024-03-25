import 'package:flutter/material.dart';

class UsuarioDetailPage extends StatefulWidget {
  dynamic user;

   UsuarioDetailPage(this.user, {Key? key}) : super(key: key);

  @override
  State<UsuarioDetailPage> createState() => _UsuarioDetailPageState();
}

class _UsuarioDetailPageState extends State<UsuarioDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(child: Text(widget.user['nome']),));
  }
}
