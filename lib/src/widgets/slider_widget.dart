import 'package:flutter/material.dart';

import 'package:apppelicula/src/models/peliculas_model.dart';

class MiSliderWidget extends StatefulWidget {
  const MiSliderWidget({
    super.key,
    required this.elementos,
    required this.siguientePagina,
  });

  final List<Pelicula> elementos;
  final Future<void> Function() siguientePagina;

  @override
  State<MiSliderWidget> createState() => _MiSliderWidgetState();
}

class _MiSliderWidgetState extends State<MiSliderWidget> {
  late final PageController _controlPagina;

  @override
  void initState() {
    super.initState();
    _controlPagina = PageController(
      initialPage: 2,
      viewportFraction: 0.33,
    );

    _controlPagina.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controlPagina
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controlPagina.hasClients) {
      return;
    }
    if (_controlPagina.position.pixels >=
        _controlPagina.position.maxScrollExtent - 200) {
      widget.siguientePagina();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.elementos.isEmpty) {
      return const SizedBox.shrink();
    }

    final Size tamanoPantalla = MediaQuery.of(context).size;
    final double tamanoDinamico =
        tamanoPantalla.width >= 580 ? 300.0 : 210.0;

    return SizedBox(
      height: tamanoDinamico,
      child: PageView.builder(
        pageSnapping: false,
        itemCount: widget.elementos.length,
        controller: _controlPagina,
        itemBuilder: (BuildContext context, int index) {
          return _crearTarjeta(context, widget.elementos[index]);
        },
      ),
    );
  }

  Widget _crearTarjeta(BuildContext context, Pelicula pelicula) {
    pelicula.miId = '${pelicula.id}-desdeSlider';

    final Container tarjeta = Container(
      margin: const EdgeInsets.only(right: 5),
      child: Column(
        children: [
          Expanded(
            child: Hero(
              tag: pelicula.miId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(pelicula.obtenerPoster()),
                ),
              ),
            ),
          ),
          Text(
            pelicula.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );

    return GestureDetector(
      child: tarjeta,
      onTap: () {
        Navigator.pushNamed(
          context,
          'detallePelicula',
          arguments: pelicula,
        );
      },
    );
  }
}
