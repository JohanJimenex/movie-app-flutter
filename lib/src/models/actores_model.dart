class Actores {
  Actores({required this.listaActores});

  factory Actores.fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) {
      return Actores(listaActores: const []);
    }

    final List<Actor> actores = jsonList
        .whereType<Map<String, dynamic>>()
        .map(Actor.fromJson)
        .toList();
    return Actores(listaActores: actores);
  }

  final List<Actor> listaActores;
}

class Actor {
  Actor({
    required this.id,
    required this.order,
    required this.castId,
    required this.adult,
    required this.job,
    required this.gender,
    required this.name,
    required this.creditId,
    required this.character,
    required this.department,
    required this.popularity,
    required this.profilePath,
    required this.originalName,
    required this.knownForDepartment,
  });

  final int id;
  final int order;
  final int castId;
  final bool adult;
  final String job;
  final int gender;
  final String name;
  final String creditId;
  final String character;
  final String department;
  final double popularity;
  final String? profilePath;
  final String originalName;
  final String knownForDepartment;

  factory Actor.fromJson(Map<String, dynamic> jsonMap) {
    return Actor(
      id: jsonMap['id'] as int? ?? 0,
      order: jsonMap['order'] as int? ?? 0,
      castId: jsonMap['cast_id'] as int? ?? 0,
      adult: jsonMap['adult'] as bool? ?? false,
      job: jsonMap['job'] as String? ?? '',
      gender: jsonMap['gender'] as int? ?? 0,
      name: jsonMap['name'] as String? ?? '',
      creditId: jsonMap['credit_id'] as String? ?? '',
      character: jsonMap['character'] as String? ?? '',
      department: jsonMap['department'] as String? ?? '',
      popularity: (jsonMap['popularity'] as num?)?.toDouble() ?? 0,
      profilePath: jsonMap['profile_path'] as String?,
      originalName: jsonMap['original_name'] as String? ?? '',
      knownForDepartment:
          jsonMap['known_for_department'] as String? ?? '',
    );
  }

  String _fallbackImage() =>
      'https://www.eduprizeschools.net/wp-content/uploads/2016/06/No_Image_Available.jpg';

  String obtenerFoto() {
    if (profilePath != null && profilePath!.isNotEmpty) {
      return 'https://image.tmdb.org/t/p/w500$profilePath';
    }
    return _fallbackImage();
  }
}
