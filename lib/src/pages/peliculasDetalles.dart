import 'package:apppelicula/src/models/actores_model.dart';
import 'package:flutter/material.dart';

import 'package:apppelicula/src/models/peliculasModel.dart';
import 'package:apppelicula/src/provider/proveedorDePeliculas.dart';

class PeliculaDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      //Sirve para crear efectos y acciones acorde a los gestos del scroll
      body: CustomScrollView(
        slivers: [
          _crearAppBar(pelicula, context),
          //similar ListView()
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 10),
              _posterTitulo(pelicula, context),
              _contenedorDetalles(pelicula, context),
              _seccionActores(pelicula, context),
            ]),
          )
        ],
      ),
    );
  }

  Widget _crearAppBar(Pelicula pelicula, context) {
    final tamanoPantalla = MediaQuery.of(context).size;

    //es como un appbar pero con mas atributos y funciones
    return SliverAppBar(
      elevation: 2.0, //sonbra
      backgroundColor: Colors.blueGrey,
      expandedHeight: tamanoPantalla.height * 0.30, //hancho
      pinned: true,
      //espacio dentro del appBar
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.all(10),
        centerTitle: true,
        title: Text(
          pelicula.title,
          textAlign: TextAlign.center,
          style: TextStyle(
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
          fadeInDuration: Duration(milliseconds: 2000),
          placeholder: AssetImage("assets/loadingSpace.gif"),
          image: NetworkImage(pelicula.obtenerBackground()),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(Pelicula pelicula, context) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: Row(
        children: [
          //hero en sliderWidget
          Hero(
            //crreamos un unico id para el hero, ya que se llama tmabiendesde el swipeWidget
            tag: pelicula.miId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                image: NetworkImage(pelicula.obetenerPoster()),
                width: 150,
              ),
            ),
          ),
          SizedBox(width: 20),
          //expande todos sus hijos
          Flexible(
            child: Column(
              //pegar a la izqueirda
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pelicula.title,
                  style: Theme.of(context).textTheme.headline6,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  pelicula.originalTitle,
                  style: Theme.of(context).textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow[800],
                    ),
                    Text(
                      pelicula.voteAverage.toString(),
                      style: Theme.of(context).textTheme.subtitle1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.date_range,
                      color: Colors.blueGrey,
                    ),
                    Text(
                      pelicula.releaseDate,
                      style: Theme.of(context).textTheme.subtitle1,
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

  Widget _contenedorDetalles(Pelicula pelicula, context) {
    return Container(
      margin: EdgeInsets.all(15),
      child: Text(
        pelicula.overview,
        style: Theme.of(context).textTheme.bodyText2,
        textAlign: TextAlign.justify,
      ),
    );
  }

  final proveedorPeliculas = new ProveedorDePeliculas();

  Widget _seccionActores(Pelicula pelicula, context) {
    // return Text("a");

    return FutureBuilder<List<Actor>>(
      future: proveedorPeliculas.obtenerActores(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _crearTarejtasActores(snapshot.data, context);
        } else {
          //se muestra cuando no tenemos informacion o mientras se resuelve el future de arriba
          return Container(
            alignment: AlignmentDirectional.center,
            padding: EdgeInsets.only(top: 1),
            child: CircularProgressIndicator(backgroundColor: Colors.blueGrey),
          );
        }
      },
    );
  }

  Widget _crearTarejtasActores(List<Actor> listaActores, context) {
    return Container(
      // height: 300,
      height: 220,
      child: PageView.builder(
          pageSnapping: false,
          itemCount: listaActores.length,
          controller: PageController(initialPage: 1, viewportFraction: 0.22),
          itemBuilder: (context, int index) {
            return _tarejtaActor(listaActores[index]);
          }),
    );
  }

  Widget _tarejtaActor(Actor actor) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FadeInImage(
              placeholder: AssetImage("assets/no-photo.png"),
              image: NetworkImage(actor.obtenerFoto()),
              fit: BoxFit.cover,
              height: 150,
            ),
          ),
          Text(
            actor.name,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
