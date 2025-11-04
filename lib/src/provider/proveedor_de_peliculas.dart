import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:apppelicula/src/models/actores_model.dart';
import 'package:apppelicula/src/models/peliculas_model.dart';

class ProveedorDePeliculas {
  ProveedorDePeliculas();

  final String _apikey = 'e4c23265a0fc540827b2f3647a8f9394';
  final String _url = 'api.themoviedb.org';
  final String idioma = 'es-ES';
  int _numeroPagina = 1;
  bool _cargando = false;

  final List<Pelicula> _listaPopulares = [];
  final StreamController<List<Pelicula>> _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  Stream<List<Pelicula>> get getPopularesStream =>
      _popularesStreamController.stream;

  void dispose() {
    _popularesStreamController.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri urlEndPoint) async {
    final http.Response respuestaJson = await http.get(urlEndPoint);

    if (respuestaJson.statusCode != 200) {
      throw Exception(
        'No se pudo cargar la información (${respuestaJson.statusCode})',
      );
    }

    final Map<String, dynamic> jsonConvertido =
        json.decode(respuestaJson.body) as Map<String, dynamic>;

    final Peliculas peliculas =
        Peliculas.fromJsonList(jsonConvertido['results'] as List<dynamic>?);

    return peliculas.items;
  }

  Future<List<Pelicula>> obtenerEnCine() async {
    final Uri url = Uri.https(
      _url,
      '3/movie/now_playing',
      {'api_key': _apikey, 'language': idioma},
    );

    return _procesarRespuesta(url);
  }

  Future<void> obtenerPopulares() async {
    if (_cargando) {
      return;
    }
    _cargando = true;

    final Uri url = Uri.https(
      _url,
      '3/movie/popular',
      {
        'api_key': _apikey,
        'language': idioma,
        'page': _numeroPagina.toString(),
      },
    );

    try {
      final List<Pelicula> respuesta = await _procesarRespuesta(url);
      _listaPopulares.addAll(respuesta);

      if (!_popularesStreamController.isClosed) {
        _popularesStreamController
            .add(List<Pelicula>.unmodifiable(_listaPopulares));
      }
      _numeroPagina++;
    } finally {
      _cargando = false;
    }
  }

  Future<List<Actor>> obtenerActores(String movieId) async {
    final Uri url = Uri.https(
      _url,
      '3/movie/$movieId/credits',
      {'api_key': _apikey, 'language': idioma},
    );

    final http.Response respJsonCrudo = await http.get(url);

    if (respJsonCrudo.statusCode != 200) {
      throw Exception(
        'No se pudieron cargar los actores (${respJsonCrudo.statusCode})',
      );
    }

    final Map<String, dynamic> jsonConvertidoAMapa =
        json.decode(respJsonCrudo.body) as Map<String, dynamic>;
    final Actores actores =
        Actores.fromJsonList(jsonConvertidoAMapa['cast'] as List<dynamic>?);
    return actores.listaActores;
  }

  Future<List<Pelicula>> buscarPelicula(String palabrasBusqueda) async {
    if (palabrasBusqueda.isEmpty) {
      return [];
    }

    final Uri url = Uri.https(
      _url,
      '3/search/movie',
      {
        'api_key': _apikey,
        'language': idioma,
        'query': palabrasBusqueda,
      },
    );

    return _procesarRespuesta(url);
  }
}
