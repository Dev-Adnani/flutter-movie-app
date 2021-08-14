import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_search_flutter/models/main.pageModel.dart';
import 'package:movies_search_flutter/models/movie.dart';
import 'package:movies_search_flutter/models/search.cat.dart';
import 'package:movies_search_flutter/services/movie.service.dart';

class MainPageModelController extends StateNotifier<MainPageModel> {
  MainPageModelController([MainPageModel? state])
      : super(state ?? MainPageModel.inital()) {
    getMovies();
  }

  final MovieService _movieService = GetIt.instance.get<MovieService>();

  Future<void> getMovies() async {
    try {
      List<Movie>? _movies = [];
      if (state.searchText!.isEmpty) {
        if (state.searchCategory == SearchCategory.popular) {
          _movies = await _movieService.getPopularMovies(page: state.page);
        } else if (state.searchCategory == SearchCategory.upcoming) {
          _movies = await _movieService.getUpcomingMovies(page: state.page);
        }
      } else {
        _movies = await _movieService.searchMovie(state.searchText!);
      }
      state = state.copyWith(
          movies: [...state.movies!, ..._movies!], page: state.page! + 1);
    } catch (e) {
      print(e);
    }
  }

  void updateSearchCategory(String? _category) {
    try {
      state = state.copyWith(
          movies: [], page: 1, searchCategory: _category, searchText: '');
      getMovies();
    } catch (e) {
      print(e);
    }
  }

  void updateTextSearch(String? _searchText) {
    try {
      state = state.copyWith(
        movies: [],
        page: 1,
        searchText: _searchText,
        searchCategory: SearchCategory.none,
      );
      getMovies();
    } catch (e) {
      print(e);
    }
  }
}
