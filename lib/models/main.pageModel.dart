import 'package:movies_search_flutter/models/movie.dart';
import 'package:movies_search_flutter/models/search.cat.dart';

class MainPageModel {
  final List<Movie>? movies;
  final int? page;
  final String? searchCategory;
  final String? searchText;

  MainPageModel({this.movies, this.page, this.searchCategory, this.searchText});

  MainPageModel.inital()
      : movies = [],
        page = 1,
        searchCategory = SearchCategory.popular,
        searchText = '';

  MainPageModel copyWith(
      {List<Movie>? movies,
      int? page,
      String? searchCategory,
      String? searchText}) {
    return MainPageModel(
        movies: movies ?? this.movies,
        page: page ?? this.page,
        searchCategory: searchCategory ?? this.searchCategory,
        searchText: searchText ?? this.searchText);
  }
}
