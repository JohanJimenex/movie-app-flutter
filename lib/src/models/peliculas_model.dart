class Peliculas {
  Peliculas({required this.items});

  factory Peliculas.fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) {
      return Peliculas(items: const []);
    }

    final List<Pelicula> peliculas = jsonList
        .whereType<Map<String, dynamic>>()
        .map(Pelicula.fromJsonMap)
        .toList();

    return Peliculas(items: peliculas);
  }

  final List<Pelicula> items;
}

class Pelicula {
  Pelicula({
    required this.id,
    required this.video,
    required this.title,
    required this.adult,
    required this.overview,
    required this.genreIds,
    required this.voteCount,
    required this.popularity,
    required this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.backdropPath,
    required this.originalTitle,
    required this.originalLanguage,
  });

  /// Identificador auxiliar para animaciones Hero.
  String? miId;

  final int id;
  final bool video;
  final String title;
  final bool adult;
  final String overview;
  final List<int> genreIds;
  final int voteCount;
  final double popularity;
  final String? posterPath;
  final double voteAverage;
  final String releaseDate;
  final String? backdropPath;
  final String originalTitle;
  final String originalLanguage;

  factory Pelicula.fromJsonMap(Map<String, dynamic> json) {
    return Pelicula(
      id: json['id'] as int? ?? 0,
      video: json['video'] as bool? ?? false,
      title: json['title'] as String? ?? '',
      adult: json['adult'] as bool? ?? false,
      overview: json['overview'] as String? ?? '',
      genreIds: (json['genre_ids'] as List<dynamic>? ?? [])
          .map((dynamic item) => item as int? ?? 0)
          .toList(),
      voteCount: json['vote_count'] as int? ?? 0,
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0,
      posterPath: json['poster_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      releaseDate: json['release_date'] as String? ?? '',
      backdropPath: json['backdrop_path'] as String?,
      originalTitle: json['original_title'] as String? ?? '',
      originalLanguage: json['original_language'] as String? ?? '',
    );
  }

  String _fallbackImage() =>
      'https://www.eduprizeschools.net/wp-content/uploads/2016/06/No_Image_Available.jpg';

  String obtenerPoster() {
    if (posterPath != null && posterPath!.isNotEmpty) {
      return 'https://image.tmdb.org/t/p/w500/$posterPath';
    }
    return _fallbackImage();
  }

  String obtenerBackground() {
    if (backdropPath != null && backdropPath!.isNotEmpty) {
      return 'https://image.tmdb.org/t/p/w500/$backdropPath';
    } else if (posterPath != null && posterPath!.isNotEmpty) {
      return 'https://image.tmdb.org/t/p/w500/$posterPath';
    }
    return _fallbackImage();
  }
}
