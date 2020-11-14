import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:noticias/creadas/mis_noticias.dart';
import 'package:noticias/models/noticia.dart';
import 'package:noticias/models/noticiaUser.dart';
import 'package:noticias/secrets.dart';

part 'noticias_event.dart';
part 'noticias_state.dart';

class NoticiasBloc extends Bloc<NoticiasEvent, NoticiasState> {
  //final apiKey = "c32f77e210d947ab805becc5625e3187";
  final Firestore _firestore = Firestore.instance;
  List<NoticiaUser> _misNoticiasList = List();
  List<NoticiaUser> get getNoticiasUser => _misNoticiasList;

  final _sportsLink =
      "https://newsapi.org/v2/top-headlines?country=mx&category=sports&apiKey=$apiKey";
  final _businessLink =
      "https://newsapi.org/v2/top-headlines?country=mx&category=business&apiKey=$apiKey";
  NoticiasBloc() : super(NoticiasInitial());

  @override
  Stream<NoticiasState> mapEventToState(
    NoticiasEvent event,
  ) async* {
    if (event is GetNewsEvent) {
      // yield lista de noticias al estado
      try {
        List<Noticia> soportsNews = await _requestSportNoticias();
        List<Noticia> businessNews = await _requestBusinessNoticias();

        yield NoticiasSuccessState(
          noticiasSportList: soportsNews,
          noticiasBusinessList: businessNews,
        );
      } catch (e) {
        yield NoticiasErrorState(message: "Error al cargar noticias: $e");
      }
    } else if (event is NoticiasUsuarioGuardadas) {
      if (await _loadlist())
        yield NoticiasUsuarioGuardadasCargadas(_misNoticiasList);
    } else if (event is CreateNoticiasUsuario) {
      yield WritteCreateNoticiasUsuario();
    } else if (event is RefreshNoticiasUsuario) {
      if (await _loadlist())
        yield NewNoticiasUsuarioGuardadasCargadas(_misNoticiasList);
    }
  }

  Future<List<Noticia>> _requestBusinessNoticias() async {
    Response response = await get(_businessLink);
    List<Noticia> _noticiasList = List();

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)["articles"];
      _noticiasList =
          ((data).map((element) => Noticia.fromJson(element))).toList();
    }
    return _noticiasList;
  }

  Future<List<Noticia>> _requestSportNoticias() async {
    Response response = await get(_sportsLink);
    List<Noticia> _noticiasList = List();

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)["articles"];
      _noticiasList =
          ((data).map((element) => Noticia.fromJson(element))).toList();
    }
    return _noticiasList;
  }

  Future<bool> _loadlist() async {
    try {
      var noticias = await _firestore.collection("MisNoticias").getDocuments();
      _misNoticiasList = noticias.documents
          .map(
            (noticias) => NoticiaUser(
              title: noticias["titulo"],
              description: noticias["descripcion"],
              urlToImage: noticias["imagen"],
            ),
          )
          .toList();
      return true;
    } catch (e) {
      print(e);
      for (var _stor in _misNoticiasList) {
        print(_stor.title);
      }
      return false;
    }
  }
}
