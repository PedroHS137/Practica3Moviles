import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noticias/noticias/bloc/noticias_bloc.dart';

class MisNoticias extends StatefulWidget {
  MisNoticias({Key key}) : super(key: key);

  @override
  _MisNoticiasState createState() => _MisNoticiasState();
}

class _MisNoticiasState extends State<MisNoticias> {
  NoticiasBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = NoticiasBloc()..add(NoticiasUsuarioGuardadas());
  }

  @override
  void setState(fn) {
    // TODO: implement setState
    _bloc.getNoticiasUser;
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    _returnEventTo() {
      _bloc.add(RefreshNoticiasUsuario());
    }

    _returnEventToCargadas() {
      _bloc.add(NoticiasUsuarioGuardadas());
    }

    return SafeArea(
      child: Scaffold(
        body: BlocProvider(
          create: (context) {
            return _bloc;
          },
          child: BlocBuilder<NoticiasBloc, NoticiasState>(
            builder: (context, state) {
              if (state is NoticiasUsuarioGuardadasCargadas) {
                return SafeArea(
                    child: Scaffold(
                  bottomNavigationBar: MaterialButton(
                    onPressed: () {
                      _returnEventTo();
                    },
                    child: Text("Refresh"),
                    color: Colors.blue,
                  ),
                  body: ListView.builder(
                    itemCount:
                        _bloc.getNoticiasUser.length, //arreglo de firebase
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: Colors.grey[200],
                        child: Column(
                          children: [
                            Image.network(
                              _bloc.getNoticiasUser[index].urlToImage,
                              width: 300,
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                            Text(
                              _bloc.getNoticiasUser[index].title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ), //titulo
                            Text(
                              _bloc.getNoticiasUser[index].description,
                              style: TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 18),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ));
              } else if (state is NewNoticiasUsuarioGuardadasCargadas) {
                return SafeArea(
                  child: Scaffold(
                    bottomNavigationBar: MaterialButton(
                      onPressed: () {
                        _returnEventToCargadas();
                      },
                      child: Text("Refresh"),
                      color: Colors.blue,
                    ),
                    body: ListView.builder(
                      itemCount:
                          _bloc.getNoticiasUser.length, //arreglo de firebase
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: Column(
                            children: [
                              Image.network(
                                  _bloc.getNoticiasUser[index].urlToImage),
                              Text(_bloc.getNoticiasUser[index].title), //titulo
                              Text(_bloc.getNoticiasUser[index].description),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
