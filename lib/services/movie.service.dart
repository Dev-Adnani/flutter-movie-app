import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_search_flutter/models/movie.dart';
import 'package:movies_search_flutter/services/http.service.dart';

class MovieService {
  final getIt = GetIt.instance;

  HTTPService? _http;

  MovieService() {
    _http = getIt.get<HTTPService>();
  }

  Future<List<Movie>?> getPopularMovies({int? page}) async {
    Response? _response = await _http!.get(
      '/movie/popular',
      query: {
        'page': page,
      },
    );
    if (_response!.statusCode == 200) {
      Map _data = _response.data;
      List<Movie>? _movies = _data['results'].map<Movie>(
        (_movieData) {
          return Movie.fromJson(_movieData);
        },
      ).toList();
      return _movies;
    } else {
      throw Exception('Couldn\'t load popular movies.');
    }
  }

  Future<List<Movie>?> getUpcomingMovies({int? page}) async {
    Response? _response = await _http!.get(
      '/movie/upcoming',
      query: {
        'page': page,
      },
    );
    if (_response!.statusCode == 200) {
      Map _data = _response.data;
      List<Movie>? _movies = _data['results'].map<Movie>(
        (_movieData) {
          return Movie.fromJson(_movieData);
        },
      ).toList();
      return _movies;
    } else {
      throw Exception('Couldn\'t load upcoming movies.');
    }
  }

  Future<List<Movie>?> searchMovie(String _searchTerm, {int? page}) async {
    Response? _response = await _http!.get(
      '/search/movie',
      query: {'page': page, 'query': _searchTerm},
    );
    if (_response!.statusCode == 200) {
      Map _data = _response.data;
      List<Movie>? _movies = _data['results'].map<Movie>((_movieData) {
        return Movie.fromJson(_movieData);
      }).toList();
      return _movies;
    } else {
      throw Exception('Couldn\'t  Load Movies Search');
    }
  }
}
