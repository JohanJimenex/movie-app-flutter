import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:apppelicula/src/pages/home_page.dart';
import 'package:apppelicula/src/pages/peliculas_detalles.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => const HomePage(),
        'detallePelicula': (BuildContext context) =>
            const PeliculaDetalle(),
      },
    );
  }
}
