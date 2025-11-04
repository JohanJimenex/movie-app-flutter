import 'package:flutter/material.dart';

import 'package:apppelicula/src/models/peliculas_model.dart';
import 'package:apppelicula/src/provider/proveedor_de_peliculas.dart';

class DatosDeBusqueda extends SearchDelegate<Pelicula?> {
  // final otrasPeliculas = [
  //   "joha",
  //   "spiderman",
  //   "adios",
  //   "pedro",
  // ];

  // final listaReciente = [
  //   "pamela",
  //   "sueprman ata",
  //   "venom",
  //   "thor",
  // ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Son las acciones de mi AppBar, por ejemplo un icono para limpiar el texto escrito o cancelar la busqueda
    //retorna una lsita de widgets
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          //esta variable guarda lo que el usuario escribe, lo limpiamo, existe por defecto
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //icono a la izqueirda del appBar, como la lupa o una flechita para regresa
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        //tiempo en el que se anima el icono
        progress: transitionAnimation,
      ),
      onPressed: () {
        //necesita el context, y el resultado que regresariamos
        close(context, null);
      },
    );
    // throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resutlados que vamos mostrar
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando el usuario va escribiendo
    //1-Operador ternario, si el query esta vacio o se a, la caja de busqueda, entonces manda las peliculas recientes
    // final listaSugeidaEscrita = (query.isEmpty)
    //     ? listaReciente
    //     //de lo contrario, aplica lo que se escribe
    //     //se retorna en una nueva lista solo que coincida con la bsuqueda
    //     : otrasPeliculas
    //         //.where es como forEach ma o meno barrre el array
    //         //si la pelicula comienza con "lo que escribe el usuario" convertido a minuscula
    //         .where((item) => item.toLowerCase().startsWith(query.toLowerCase()))
    //         .toList(); //lo convertimo a lista ya que lo que regresa es un iterable de cada elemento

    // return ListView.builder(
    //   itemCount: listaSugeidaEscrita.length,
    //   itemBuilder: (context, index) {
    //     return ListTile(
    //       leading: Icon(Icons.movie),
    //       title: Text(listaSugeidaEscrita[index]),
    //       onTap: () {
    //         //guardamo el elemento en la variable seleccion
    //         // seleccion = listaSugeidaEscrita[index];
    //         //para construir el resultado
    //         // showResults(context);
    //       },
    //     );
    //   },
    // );

    if (query.isEmpty) {
      return Container(); //prevenir algun error
    }

    final ProveedorDePeliculas proveedorPelicula = ProveedorDePeliculas();

    return FutureBuilder<List<Pelicula>>(
      //mandamo el query que escribe el usuario
      future: proveedorPelicula.buscarPelicula(query),
      initialData: const [],
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final List<Pelicula> listaPeliculas = snapshot.data ?? const [];

          return ListView.builder(
            itemCount: listaPeliculas.length,
            itemBuilder: (context, index) {
              final Pelicula pelicula = listaPeliculas[index];
              return ListTile(
                leading: FadeInImage(
                  placeholder: const AssetImage("assets/no-image.jpg"),
                  image: NetworkImage(pelicula.obtenerPoster()),
                  width: 50,
                  fit: BoxFit.contain,
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: () {
                  pelicula.miId ??= '${pelicula.id}-busqueda';
                  close(context, null);
                  Navigator.pushNamed(
                    context,
                    "detallePelicula",
                    arguments: pelicula,
                  );
                },
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
