import 'package:flutter/material.dart';

import 'package:apppelicula/src/models/actores_model.dart';
import 'package:apppelicula/src/models/peliculas_model.dart';
import 'package:apppelicula/src/provider/proveedor_de_peliculas.dart';

class PeliculaDetalle extends StatefulWidget {
  const PeliculaDetalle({super.key});

  @override
  State<PeliculaDetalle> createState() => _PeliculaDetalleState();
}

class _PeliculaDetalleState extends State<PeliculaDetalle> {
  late final ProveedorDePeliculas _proveedorPeliculas;
  Future<List<Actor>>? _actoresFuture;
  Pelicula? _pelicula;
  late final PageController _actoresController;

  @override
  void initState() {
    super.initState();
    _proveedorPeliculas = ProveedorDePeliculas();
    _actoresController =
        PageController(initialPage: 1, viewportFraction: 0.22);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    if (_pelicula == null && args is Pelicula) {
      _pelicula = args;
      _actoresFuture =
          _proveedorPeliculas.obtenerActores(_pelicula!.id.toString());
    }
  }

  @override
  void dispose() {
    _proveedorPeliculas.dispose();
    _actoresController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = _pelicula ??
        (ModalRoute.of(context)?.settings.arguments as Pelicula);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _crearAppBar(pelicula, context),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 10),
              _posterTitulo(pelicula, context),
              _contenedorDetalles(pelicula, context),
              _seccionActores(context),
            ]),
          )
        ],
      ),
    );
  }

  SliverAppBar _crearAppBar(Pelicula pelicula, BuildContext context) {
    final Size tamanoPantalla = MediaQuery.of(context).size;

    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.blueGrey,
      expandedHeight: tamanoPantalla.height * 0.30,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.all(10),
        centerTitle: true,
        title: Text(
          pelicula.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            shadows: [
              Shadow(
                blurRadius: 7.0,
                color: Colors.black,
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
        background: FadeInImage(
          fadeInDuration: const Duration(milliseconds: 200),
          placeholder: const AssetImage('assets/loadingSpace.gif'),
          image: NetworkImage(pelicula.obtenerBackground()),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(Pelicula pelicula, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: [
          Hero(
            tag: pelicula.miId ?? '${pelicula.id}-detalle',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                image: NetworkImage(pelicula.obtenerPoster()),
                width: 150,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pelicula.title,
                  style: Theme.of(context).textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  pelicula.originalTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      pelicula.voteAverage.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.date_range,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      pelicula.releaseDate,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _contenedorDetalles(Pelicula pelicula, BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Text(
        pelicula.overview,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _seccionActores(BuildContext context) {
    final Future<List<Actor>>? future = _actoresFuture;
    if (future == null) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<List<Actor>>(
      future: future,
      builder: (
        BuildContext context,
        AsyncSnapshot<List<Actor>> snapshot,
      ) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return _crearTarjetasActores(snapshot.data!, context);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            alignment: AlignmentDirectional.center,
            padding: const EdgeInsets.only(top: 16),
            child: const CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'No se pudieron cargar los actores.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'No hay reparto disponible.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          );
        }
      },
    );
  }

  Widget _crearTarjetasActores(List<Actor> listaActores, BuildContext context) {
    return SizedBox(
      height: 220,
      child: PageView.builder(
        pageSnapping: false,
        itemCount: listaActores.length,
        controller: _actoresController,
        itemBuilder: (BuildContext context, int index) {
          return _tarjetaActor(listaActores[index], context);
        },
      ),
    );
  }

  Widget _tarjetaActor(Actor actor, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-photo.png'),
              image: NetworkImage(actor.obtenerFoto()),
              fit: BoxFit.cover,
              height: 150,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            actor.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
