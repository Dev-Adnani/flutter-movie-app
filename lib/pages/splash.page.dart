import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_search_flutter/models/app.config.dart';
import 'package:movies_search_flutter/services/http.service.dart';
import 'package:movies_search_flutter/services/movie.service.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onIntialComplete;
  const SplashPage({Key? key, required this.onIntialComplete})
      : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 2),
    ).then(
      (_) => _setup(context).then(
        (_) => widget.onIntialComplete(),
      ),
    );
  }

  Future<void> _setup(BuildContext _context) async {
    final getIt = GetIt.instance;

    final config = await rootBundle.loadString('assets/config/main.json');
    final configData = jsonDecode(config);

    getIt.registerSingleton<AppConfig>(
      AppConfig(
        BASE_API_URL: configData['BASE_API_URL'],
        API_KEY: configData['API_KEY'],
        BASE_IMAGE_API_URL: configData['BASE_IMAGE_API_URL'],
      ),
    );

    getIt.registerSingleton<HTTPService>(
      HTTPService(),
    );

    getIt.registerSingleton<MovieService>(
      MovieService(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Movie App",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Center(
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage('assets/images/icon.png'),
            ),
          ),
        ),
      ),
    );
  }
}
