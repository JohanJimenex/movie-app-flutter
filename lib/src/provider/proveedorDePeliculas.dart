import 'dart:async'; //para usar el stream controller
import 'dart:convert';
import 'package:http/http.dart' as http;
//para hacer peticiones http (get/post etc) //el 'as' es opcional para no hacer peticiones solo con get
import 'package:apppelicula/src/models/actores_model.dart';
import 'package:apppelicula/src/models/peliculasModel.dart';
// import 'package:apppelicula/src/modelos/peliculasModel.dart';

class ProveedorDePeliculas {
  //
  String _apikey = "e4c23265a0fc540827b2f3647a8f9394";
  String _url = "api.themoviedb.org";
  String idioma = "es-ES";
  int _numeroPagina = 1;
  bool _cargando = false;

  //para agregarla al Stream
  List<Pelicula> _listaPopulares = new List();

  //Creacion de un stream========>
  //se indica que tipo de datos va a fluir, y el .broacast es para poder escuchar de varios lugares
  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  //implementemamos un get
  //optional Function(List<Pelicula>) sirve para controllar los datos que le enviemos
  Function(List<Pelicula>) get getPopularesSink {
    //para insertar informacion al stream
    return _popularesStreamController.sink.add; //para argegar peliculas
  }

  //implementemamos un get (como lo tengo en mis notas massCode)
  //opcional Stream<List<Pelicula>>
  Stream<List<Pelicula>> get getPopularesStream {
    //para escuchar informacion(peliculas) del stream,
    return _popularesStreamController.stream;
  }

  //para cerrar el stream ya que nos e puede quedar abierto, para poderlo llamar de otras paginas
  //aunque no se esta llamando , lo ponemos para que el Stream de arriba no de eerror
  //el signo de interrogacion pregunta que si tiene el metodo closes, se ejecute.
  void espose() {
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri urlEndPoint) async {
    //Agregar libreria http: ^0.12.0+2 en el pubspec.yaml u otra version mas moderna
    final respuestaJson = await http.get(urlEndPoint);
    //viene un Map<"String", dynamic> // importar dar:convert, para el decode
    final jsonConvertido = json.decode(respuestaJson.body);

    //El constructor con nombre 'desdeJsonLista' tiene un bucle que recorre la lista 'results'
    final peliculas = new Peliculas.fromJsonList(jsonConvertido["results"]);

    print("procesarDatos");

    return peliculas.items;
  }

  Future<List<Pelicula>> obtenerEnCine() async {
    // String urlConcatenado = "https:"+_url+"/3/movie/now_playing?api_key="+_apikey+"&language="+idioma+"&page=1";
    //Concatena una URL agregando el http automatico y lso otros paremtros
    final url = Uri.https(
      _url,
      "3/movie/now_playing",
      {'api_key': _apikey, 'language': idioma},
    );

    print("obtenerEnCine hecho");

    return await _procesarRespuesta(url);
  }

  Future obtenerPopulares() async {
    final url = Uri.https(
      _url,
      "3/movie/popular",
      {
        'api_key': _apikey,
        'language': idioma,
        "page": _numeroPagina.toString()
      },
    );
    if (_numeroPagina <= 5 && _cargando == false) {
      _cargando = true;

      print(_numeroPagina);

      final respuesta = await _procesarRespuesta(url);

      //agregaremos todas las peliculas a mi stream, a mi rio xD
      //.add() agrega una nueva pelicula, .addAll() recibe un iterable
      _listaPopulares.addAll(respuesta);

      //utilizamos mi sink para agregar datos al stream
      getPopularesSink(_listaPopulares);
      _numeroPagina++;
      _cargando = false;

      print("Se hizo una peticion a Get Popular y  GetPupularSink");
    }
  }

  Future<List<Actor>> obtenerActores(String movieId) async {
    //IMPORTANTE. me daba error por colocar la ruta como dice el api... y faltaba un 3
    final url = Uri.https(
      _url,
      "3/movie/$movieId/credits",
      {"api_key": _apikey, "language": idioma},
    );

    final respJsonCrudo = await http.get(url);
    final jsonConvertidoAMapa = json.decode(respJsonCrudo.body);
    final actores = Actores.fromJsonList(jsonConvertidoAMapa["cast"]);
    return actores.listaActores;
  }

  Future<List<Pelicula>> buscarPelicula(String palabrasBusqueda) async {
    // String urlConcatenado = "https:"+_url+"/3/movie/now_playing?api_key="+_apikey+"&language="+idioma+"&page=1";
    //Concatena una URL agregando el http automatico y lso otros paremtros
    final url = Uri.https(
      _url,
      "3/search/movie",
      {
        'api_key': _apikey,
        'language': idioma,
        'query': palabrasBusqueda,
      },
    );

    print("obtenerEnCine hecho");

    return await _procesarRespuesta(url);
  }
}
