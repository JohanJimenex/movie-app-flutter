//clase Peliculas, esta es la que voy a instanciar
class Peliculas {
  List<Pelicula> items = new List();

  //contrsutcor con nombre y parametros
  Peliculas.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      Pelicula pelicula = new Pelicula.fromJsonMap(item);
      items.add(pelicula);
    }
    print("Se hizo una instancia de Pelicula del modelo");
  }
}

//clase Pelicula
class Pelicula {
  //Mi id par amanejar los Hero
  String miId = "";

  int id;
  bool adult;
  bool video;
  String title;
  int voteCount;
  String overview;
  String posterPath;
  double popularity;
  String releaseDate;
  List<int> genreIds;
  double voteAverage;
  String backdropPath;
  String originalTitle;
  String originalLanguage;

  //Constructor con nombre y parametro
  Pelicula.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'];
    video = json['video'];
    title = json['title'];
    adult = json['adult'];
    overview = json['overview'];
    genreIds = json['genre_ids'].cast<int>(); //lo convierte a enteros
    voteCount = json['vote_count'];
    popularity = json['popularity'] / 1;
    posterPath = json['poster_path'];
    voteAverage = json['vote_average'] / 1; //lo divide en 1 por si no es double
    releaseDate = json['release_date'];
    backdropPath = json['backdrop_path'];
    originalTitle = json['original_title'];
    originalLanguage = json['original_language'];
  }

  String obetenerPoster() {
    if (posterPath != null) {
      return "https://image.tmdb.org/t/p/w500/$posterPath";
    } else {
      return "https://www.eduprizeschools.net/wp-content/uploads/2016/06/No_Image_Available.jpg";
    }
  }

  String obtenerBackground() {
    if (backdropPath != null) {
      return "https://image.tmdb.org/t/p/w500/$backdropPath";
    } else if (posterPath != null) {
      return "https://image.tmdb.org/t/p/w500/$posterPath";
    } else {
      return "https://www.eduprizeschools.net/wp-content/uploads/2016/06/No_Image_Available.jpg";
    }
  }
}
