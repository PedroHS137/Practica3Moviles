import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:noticias/creadas/mis_noticias.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noticias/noticias/bloc/noticias_bloc.dart';

class CrearNoticia extends StatefulWidget {
  CrearNoticia({Key key}) : super(key: key);

  @override
  _CrearNoticiaState createState() => _CrearNoticiaState();
}
// TODO: Formulario para crear noticias
// tomar fotos de camara o de galeria

class _CrearNoticiaState extends State<CrearNoticia> {
  @override
  NoticiasBloc _bloc;
  final Firestore _firestore = Firestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = NoticiasBloc()..add(CreateNoticiasUsuario());
  }

  Widget build(BuildContext context) {
    TextEditingController textTitle = new TextEditingController();
    TextEditingController textDescription = new TextEditingController();
    TextEditingController textimage = new TextEditingController();
    _returnEventTo() {
      _bloc.add(CreateNoticiasUsuario());
    }

    return SafeArea(
      child: Scaffold(
        body: BlocProvider(
          create: (context) {
            return _bloc;
          },
          child: BlocBuilder<NoticiasBloc, NoticiasState>(
            builder: (context, state) {
              if (state is WritteCreateNoticiasUsuario) {
                return SafeArea(
                  child: Scaffold(
                    body: Column(
                      children: [
                        Text("ingresa el titulo"),
                        TextFormField(
                          controller: textTitle,
                          decoration: const InputDecoration(
                            hintText: 'ingresa el tiutlo',
                          ),
                        ),
                        TextFormField(
                          controller: textDescription,
                          decoration: const InputDecoration(
                            hintText: 'ingresa la descripcion',
                          ),
                        ),
                        TextFormField(
                          controller: textimage,
                          decoration: const InputDecoration(
                            hintText: 'ingresa el link de la imagen',
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                          child: Text("Guardar"),
                          color: Colors.blue,
                          onPressed: () {
                            _pushOrder(
                              textTitle.text,
                              textDescription.text,
                              textimage.text,
                            );
                            _bloc.add(NoticiasUsuarioGuardadas());
                          },
                        ),
                      ],
                    ),
                  ),
                );
              } else
                return Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      MaterialButton(
                        onPressed: () {
                          _returnEventTo();
                        },
                        child: Text("Crear nueva noticia"),
                        color: Colors.blue,
                      )
                    ],
                  ),
                );
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _pushOrder(titulo, desc, image) async {
    print("Entra");
    print(titulo);
    print(desc);
    print(image);

    try {
      await _firestore
          .collection("MisNoticias")
          .document()
          .setData({"titulo": titulo, "descripcion": desc, "imagen": image});

      // Navigator.of(context).pushReplacement(MaterialPageRoute(
      //   builder: (context) => MisNoticias(),
      // ));
      //BlocProvider.of<NoticiasBloc>(context).add(NoticiasUsuarioGuardadas());
      return true;
    } catch (err) {
      print(err.toString());
      return false;
    }
  }
}
