import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_search_flutter/controller/main.page.model.controller.dart';
import 'package:movies_search_flutter/models/main.pageModel.dart';
import 'package:movies_search_flutter/models/movie.dart';
import 'package:movies_search_flutter/models/search.cat.dart';
import 'package:movies_search_flutter/widgets/movie_tile.dart';

final mainPageDataControllerProvider =
    StateNotifierProvider<MainPageModelController, MainPageModel>(
  (ref) {
    return MainPageModelController();
  },
);

final selectedMoviePosterURLProvider = StateProvider<String?>(
  (ref) {
    final _movies = ref.watch(mainPageDataControllerProvider).movies!;
    return _movies.length != 0 ? _movies[0].posterURL() : null;
  },
);

class MainPage extends ConsumerWidget {
  double? _devHeight;
  double? _devWidth;
  late var _selectedMoviePosterURL;

  late MainPageModelController _mainPageModelController;
  late MainPageModel _mainPageModel;

  TextEditingController? _searchTextFieldController;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    _devHeight = MediaQuery.of(context).size.height;
    _devWidth = MediaQuery.of(context).size.width;
    _mainPageModelController = watch(mainPageDataControllerProvider.notifier);
    _mainPageModel = watch(mainPageDataControllerProvider);
    _searchTextFieldController = TextEditingController();
    _searchTextFieldController!.text = _mainPageModel.searchText!;
    _selectedMoviePosterURL = watch(selectedMoviePosterURLProvider);
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black87,
      body: Container(
        height: _devHeight,
        width: _devWidth,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _backgroundWidget(),
            _foregroundWidgets(),
          ],
        ),
      ),
    );
  }

  Widget _backgroundWidget() {
    if (_selectedMoviePosterURL.state != null) {
      return Container(
        height: _devHeight,
        width: _devWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: NetworkImage(
              _selectedMoviePosterURL.state,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
          ),
        ),
      );
    } else {
      return Container(
        height: _devHeight,
        width: _devWidth,
        color: Colors.black87,
      );
    }
  }

  Widget _foregroundWidgets() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, _devHeight! * 0.02, 0, 0),
      width: _devWidth! * 0.88,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _topBarWidget(),
          Container(
            height: _devHeight! * 0.83,
            padding: EdgeInsets.symmetric(vertical: _devHeight! * 0.01),
            child: _moviesListViewWidget(),
          ),
        ],
      ),
    );
  }

  Widget _topBarWidget() {
    return Container(
      height: _devHeight! * 0.08,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _searchFieldWidget(),
          _categorySelectionWidget(),
        ],
      ),
    );
  }

  Widget _searchFieldWidget() {
    final _border = InputBorder.none;
    return Container(
      width: _devWidth! * 0.50,
      height: _devHeight! * 0.05,
      child: TextField(
        onSubmitted: (_input) =>
            _mainPageModelController.updateTextSearch(_input),
        decoration: InputDecoration(
            focusedBorder: _border,
            border: _border,
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white24,
            ),
            hintStyle: TextStyle(
              color: Colors.white54,
            ),
            filled: false,
            fillColor: Colors.white24,
            hintText: "Search..."),
        style: TextStyle(color: Colors.white),
        controller: _searchTextFieldController,
      ),
    );
  }

  Widget _categorySelectionWidget() {
    return DropdownButton(
      dropdownColor: Colors.black38,
      value: _mainPageModel.searchCategory,
      icon: Icon(
        Icons.menu,
        color: Colors.white24,
      ),
      onChanged: (_value) => _value.toString().isNotEmpty
          ? _mainPageModelController.updateSearchCategory(_value.toString())
          : null,
      underline: Container(
        height: 1,
        color: Colors.white24,
      ),
      items: [
        DropdownMenuItem(
          child: Text(
            SearchCategory.popular,
            style: TextStyle(color: Colors.white),
          ),
          value: SearchCategory.popular,
        ),
        DropdownMenuItem(
          child: Text(
            SearchCategory.upcoming,
            style: TextStyle(color: Colors.white),
          ),
          value: SearchCategory.upcoming,
        ),
        DropdownMenuItem(
          child: Text(
            SearchCategory.none,
            style: TextStyle(color: Colors.white),
          ),
          value: SearchCategory.none,
        ),
      ],
    );
  }

  Widget _moviesListViewWidget() {
    final List<Movie>? _movies = _mainPageModel.movies;

    if (_movies!.length != 0) {
      return NotificationListener(
        onNotification: (_onScrollNotify) {
          if (_onScrollNotify is ScrollEndNotification) {
            final before = _onScrollNotify.metrics.extentBefore;
            final max = _onScrollNotify.metrics.maxScrollExtent;
            if (before == max) {
              _mainPageModelController.getMovies();
              return true;
            }
            return false;
          } else
            return false;
        },
        child: ListView.builder(
          itemCount: _movies.length,
          itemBuilder: (BuildContext _context, int count) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  vertical: _devHeight! * 0.01, horizontal: 0),
              child: GestureDetector(
                onTap: () {
                  _selectedMoviePosterURL.state = _movies[count].posterURL();
                },
                child: MovieTile(
                  height: _devHeight! * 0.20,
                  width: _devWidth! * 0.85,
                  movie: _movies[count],
                ),
              ),
            );
          },
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      );
    }
  }
}
