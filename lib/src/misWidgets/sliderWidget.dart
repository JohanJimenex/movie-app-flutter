import 'package:flutter/material.dart';

import 'package:apppelicula/src/models/peliculasModel.dart';

class MiSliderWidget extends StatelessWidget {
  final List<Pelicula> elementos;
  final Function siguientePagina;

  //constructor
  MiSliderWidget({@required this.elementos, @required this.siguientePagina});

  @override
  Widget build(BuildContext context) {
    final tamanoPantalla = MediaQuery.of(context).size;
    double tamanoDinamico;

    if (tamanoPantalla.width >= 580) {
      tamanoDinamico = 300.00;
    } else {
      tamanoDinamico = 210.00;
    }

    final controlPagina = PageController(
      initialPage: 2, // iniciar en la pagina x
      //cuantas miniImagenes mostrar 0.35 de 1
      viewportFraction: 0.33,
    );

    // //Establece el cuantas tarejtas mostrar en el viewPort
    // if (tamanoPantalla.width >= 580) {
    //   tamanoDivision = 0.22;
    // } else {
    //   tamanoDivision = 0.33;
    // }

    //obtener la posicion en pixele del pageControl para llamar mas elementos
    controlPagina.addListener(() {
      if (controlPagina.position.pixels >=
          controlPagina.position.maxScrollExtent - 200) {
        siguientePagina();
      }
    });

    return SizedBox(
      height: tamanoDinamico, // parte dela pantalla
      // height: 300, // parte dela pantalla
      //pageViw igual que listView tiene un metodo para cargarlo contra demanda, sino lo carga todos al mismo tiempo
      child: PageView.builder(
        pageSnapping: false, //deslizar pisao
        itemCount: elementos.length,
        controller: controlPagina,
        // children: tarjetas(context),//se usaba con el otro codigo de abajo
        itemBuilder: (BuildContext context, int index) {
          return crearTarjetasParaPageView(context, elementos[index]);
        },
      ),
    );
  }

//este es el mismo codigo de abajo pero se llama para el itenBuider
  Widget crearTarjetasParaPageView(BuildContext context, Pelicula pelicula) {
    //miId agregado en la clase modelo para manejar los hero
    pelicula.miId = "${pelicula.id}-desdeSlider";

    Container tarjeta = Container(
      margin: EdgeInsets.only(right: 5),
      child: Column(
        children: [
          Expanded(
            //Hero en peliculasDetalles.dart Trasladar imagen a nueva pagina
            child: Hero(
              tag: pelicula.miId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage(
                  // height: 180,
                  fit: BoxFit.cover,
                  placeholder: AssetImage("assets/no-image.jpg"),
                  image: NetworkImage(pelicula.obetenerPoster()),
                ),
              ),
            ),
          ),
          Text(
            pelicula.title,
            overflow: TextOverflow.ellipsis, //cortar texto con ...
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );

    return GestureDetector(
      child: tarjeta,
      onTap: () {
        Navigator.pushNamed(context, "detallePelicula", arguments: pelicula);
      },
    );
  }

/*Esta crea se usaba para el chidred de un pageView sin su builder
una primera tarjeta sal iniciar la aplicacion mapeando el array elementos*/
  // List<Widget> tarjetas(BuildContext context) {
  //   //MiArrayList.map(elemento)retorna un nuevo array de lo que recogio
  //   return elementos.map((pelicula) {
  //     return Container(
  //       child: Column(
  //         children: [
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(10),
  //             child: FadeInImage(
  //               height: 190,
  //               fit: BoxFit.cover,
  //               placeholder: AssetImage("assets/no-image.jpg"),
  //               image: NetworkImage(pelicula.obetenerPoster()),
  //             ),
  //           ),
  //           Text(
  //             pelicula.title,
  //             overflow: TextOverflow.ellipsis, //cortar texto con ...
  //             style: Theme.of(context).textTheme.subtitle1,
  //           ),
  //         ],
  //       ),
  //     );
  //   }).toList(); // convertilo a lsita
  // }
}
