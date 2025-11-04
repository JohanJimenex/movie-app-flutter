import 'package:flutter/material.dart';

import 'package:apppelicula/src/models/peliculas_model.dart';
import 'package:apppelicula/src/provider/proveedor_de_peliculas.dart';
import 'package:apppelicula/src/seach/search_delegate.dart';
import 'package:apppelicula/src/widgets/slider_widget.dart';
import 'package:apppelicula/src/widgets/swipe_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ProveedorDePeliculas proveedorPeliculass;

  @override
  void initState() {
    super.initState();
    proveedorPeliculass = ProveedorDePeliculas();
    proveedorPeliculass.obtenerPopulares();
  }

  @override
  void dispose() {
    proveedorPeliculass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peliculas'),
        backgroundColor: Colors.blueGrey.shade900,
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 10),
            icon: const Icon(
              Icons.search,
              size: 30,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DatosDeBusqueda(),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                _crearSwipeTarjetas(),
                _footer(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearSwipeTarjetas() {
    return FutureBuilder<List<Pelicula>>(
      future: proveedorPeliculass.obtenerEnCine(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<Pelicula>> snapshot,
      ) {
        if (snapshot.hasData) {
          return MiSwipeCard(elementos: snapshot.data ?? const []);
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Ocurrió un error al cargar la cartelera.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return Container(
            alignment: AlignmentDirectional.center,
            padding: const EdgeInsets.only(top: 16),
            child: const CircularProgressIndicator(
              backgroundColor: Colors.blueGrey,
            ),
          );
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: double.infinity,
      alignment: AlignmentDirectional.center,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Populares',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          StreamBuilder<List<Pelicula>>(
            stream: proveedorPeliculass.getPopularesStream,
            initialData: const [],
            builder:
                (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return MiSliderWidget(
                  elementos: snapshot.data!,
                  siguientePagina: proveedorPeliculass.obtenerPopulares,
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'No se pudieron cargar las películas populares.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'No hay películas populares disponibles.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
