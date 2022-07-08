import 'package:apppelicula/src/models/peliculasModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class MiSwipeCard extends StatelessWidget {
  //
  final List<Pelicula> elementos;
  //
  MiSwipeCard({@required this.elementos}); //constructor moderno

  @override
  Widget build(BuildContext context) {
    //Media query para detectar tamano de pantallas del dispositivo
    final tamanoPantalla = MediaQuery.of(context).size;

    double altura;

    if (tamanoPantalla.height >= 900) {
      altura = 0.60;
    } else {
      altura = 0.50;
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Text("En cine", style: Theme.of(context).textTheme.headline6),
        ),
        Swiper(
          //estilo de las taerjetas (ver mas en la documentacion)
          layout: SwiperLayout.STACK,
          // cantidad de elementos a mostrar, ejecuta el metodo de abajo "itemBuilder"
          //las veces establecida, es un bucle con su index
          itemCount: elementos.length,
          //Este es un bucle con su index, se ejecuta las veces establecida arriba itemCount
          itemBuilder: (BuildContext context, int index) {
            //miId agregado en la clase modelo para manejar los hero
            elementos[index].miId = "${elementos[index].id}-desdeswipeWidget";

            return ListView(
              children: [
                Hero(
                  //crreamos un unico id para el hero, ya que se llama tmabiendesde el peliculasDetalles
                  tag: elementos[index].miId,
                  child: ClipRRect(
                    //permite agregar borderRadius a sus hijos
                    borderRadius: BorderRadius.circular(20.0),
                    child: GestureDetector(
                      child: FadeInImage(
                        placeholder: AssetImage("assets/no-image.jpg"),
                        // image: NetworkImage("https://image.tmdb.org/t/p/w500/${elementos[index].posterPath}"),
                        image: NetworkImage(elementos[index].obetenerPoster()),
                        fit: BoxFit.fill,
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, "detallePelicula",
                            arguments: elementos[index]);
                      },
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Text(
                    elementos[index].title,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ],
            );
          },
          //quiero el 70% de la pantalla, ancho de tarjetas
          itemWidth: tamanoPantalla.width * 0.60,
          itemHeight: tamanoPantalla.height * altura, //la mitad de pantalla
          // itemHeight: tamanoPantalla.height / 2, //la mitad de pantalla
          // pagination: new SwiperPagination(), // los botoncitos de abajo
          // control: new SwiperControl(), // las flechas de los lados
        ),
      ],
    );
  }
}
