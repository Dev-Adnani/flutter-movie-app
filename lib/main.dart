import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_search_flutter/pages/main.page.dart';
import 'package:movies_search_flutter/pages/splash.page.dart';

void main() {
  runApp(
    SplashPage(
      key: UniqueKey(),
      onIntialComplete: () => runApp(
        ProviderScope(
          child: Lava(),
        ),
      ),
    ),
  );
}

class Lava extends StatelessWidget {
  const Lava({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Movie-App",
      routes: {'home': (BuildContext _context) => MainPage()},
      initialRoute: 'home',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity),
    );
  }
}
