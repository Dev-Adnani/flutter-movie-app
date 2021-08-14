import 'package:get_it/get_it.dart';
import 'package:movies_search_flutter/models/app.config.dart';

class Movie {
  final String? name;
  final String? lang;
  final String? desc;
  final String? posterPath;
  final bool? isAdult;
  final String? backdropPath;
  final num? rating;
  final String? releaseDate;

  Movie({
    this.name,
    this.lang,
    this.desc,
    this.posterPath,
    this.isAdult,
    this.backdropPath,
    this.rating,
    this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> _json) {
    return Movie(
      name: _json['title'],
      lang: _json['original_language'],
      desc: _json['overview'],
      posterPath: _json['poster_path'],
      isAdult: _json['adult'],
      backdropPath: _json['backdrop_path'],
      rating: _json['vote_average'],
      releaseDate: _json['release_date'],
    );
  }

  String posterURL() {
    final AppConfig _appConfig = GetIt.instance.get<AppConfig>();
    return '${_appConfig.BASE_IMAGE_API_URL}${this.posterPath}';
  }
}
