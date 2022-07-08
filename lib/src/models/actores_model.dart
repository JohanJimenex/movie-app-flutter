class Actores {
  List<Actor> listaActores = new List();

  Actores.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      Actor actor = Actor.fromJson(item);
      listaActores.add(actor);
    }
  }
}

class Actor {
  int id;
  int order;
  int castId;
  bool adult;
  String job;
  int gender;
  String name;
  String creditId;
  String character;
  String department;
  double popularity;
  String profilePath;
  String originalName;
  String knownForDepartment;

  Actor.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap["id"];
    order = jsonMap["order"];
    castId = jsonMap["cast_id"];
    adult = jsonMap["adult"];
    job = jsonMap["job"];
    //=============================================================================================================
    //IMPORTANTE cambiar las mayusculas de la clave del json a minuscula y rayita abajo como esta en el json original
    //=============================================================================================================
    gender = jsonMap["gender"];
    name = jsonMap["name"];
    creditId = jsonMap["credit_id"];
    character = jsonMap["character"];
    department = jsonMap["department"];
    popularity = jsonMap["popularity"];
    profilePath = jsonMap["profile_path"];
    originalName = jsonMap["original_name"];
    knownForDepartment = jsonMap["known_for_department"];
  }

  String obtenerFoto() {
    if (profilePath != null) {
      return "https://image.tmdb.org/t/p/w500$profilePath";
    } else {
      return "https://www.eduprizeschools.net/wp-content/uploads/2016/06/No_Image_Available.jpg";
    }
  }
}
