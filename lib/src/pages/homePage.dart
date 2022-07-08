import 'package:apppelicula/src/models/peliculasModel.dart';
import 'package:flutter/material.dart';

import 'package:apppelicula/src/seach/search_delegate.dart';
import 'package:apppelicula/src/misWidgets/swipeWidget.dart';
import 'package:apppelicula/src/misWidgets/sliderWidget.dart';
import 'package:apppelicula/src/provider/proveedorDePeliculas.dart';

class HomePage extends StatelessWidget {
  
  final proveedorPeliculass = new ProveedorDePeliculas();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Peliculas"),
        backgroundColor: Colors.blueGrey[900],
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 10),
            icon: Icon(
              Icons.search,
              size: 30,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DatosDeBusqueda(),
                // query: "hola",//coloca un texto en la caja, se puede jugar con ella
              );
            },
          ),
        ],
      ),
      /* SafeArea Es para evitar que los objetos se salgan del margen ,
      por ejemplo los celulares que tienenn snochk*/
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                crearSwipeTarjetas(),
                footer(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget crearSwipeTarjetas() {
    return FutureBuilder<List<Pelicula>>(
      future: proveedorPeliculass.obtenerEnCine(),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        //hasData es si tiene datos, o sea diferente de null
        if (snapshot.hasData) {
          return MiSwipeCard(elementos: snapshot.data);
        } else {
          //se muestra cuando no tenemos informacion o mientras se resuelve el future de arriba
          return Container(
            alignment: AlignmentDirectional.center,
            padding: EdgeInsets.only(top: 1),
            child: CircularProgressIndicator(
              backgroundColor: Colors.blueGrey,
            ),
          );
        }
      },
    );
  }

  Widget footer(BuildContext context) {
    //llamamor el metodo que hace la llamad aa la API y llena el stream con los datos
    //no es necesario porque se llama en el sliderWidget porque la aplicacion inicia con el pixel <= al que tiene
    //pero por si acaso... y se cargarian dos paginas
    proveedorPeliculass.obtenerPopulares();

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: double.infinity,
      alignment: AlignmentDirectional.center,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child:
                Text("Populares", style: Theme.of(context).textTheme.subtitle1),
          ),
          StreamBuilder<List<Pelicula>>(
            //el stream esta esperando llenarse de datos, con el metodo arriba: proveedorPeliculass.obtenerPopulares();
            stream: proveedorPeliculass.getPopularesStream,
            initialData: [],
            builder:
                (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
              if (snapshot.hasData) {
                return MiSliderWidget(
                    elementos: snapshot.data,
                    siguientePagina: proveedorPeliculass.obtenerPopulares);
              } else {
                return Container(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
