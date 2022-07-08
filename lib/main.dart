import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:apppelicula/src/pages/homePage.dart';
import 'package:apppelicula/src/pages/peliculasDetalles.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //Bloquear orientaciond e pantalla a portrait 
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (BuildContext context) => HomePage(),
        "detallePelicula": (BuildContext context) => PeliculaDetalle(),
      },
    );
  }
}
