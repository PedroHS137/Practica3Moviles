import 'package:flutter/material.dart';

class Buscar extends StatefulWidget {
  Buscar({Key key}) : super(key: key);

  @override
  _BuscarState createState() => _BuscarState();
}

class _BuscarState extends State<Buscar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Buscar"),
      actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
    );
  }
}
