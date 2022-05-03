import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

class CantidadCrear extends StatefulWidget {
  final num precio;
  final Function callbackPrecio;
  const CantidadCrear({
    Key? key,
    required this.precio,
    required this.callbackPrecio,
  }) : super(key: key);

  @override
  _CantidadCrearState createState() => _CantidadCrearState();
}

class _CantidadCrearState extends State<CantidadCrear> {
  num precio = 1.0;
  @override
  void initState() {
    super.initState();
    setState(() {
      precio = widget.precio;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: SpinBox(
          max: 10000.0,
          value: precio.toDouble(),
          decimals: 1,
          step: 0.1,
          decoration: const InputDecoration(
              labelText: 'Cantidad a penalizar',
              floatingLabelAlignment: FloatingLabelAlignment.center,
              contentPadding: EdgeInsets.only(bottom: 8.0)),
          onChanged: (value) {
            setState(() {
              precio = value;
            });
            widget.callbackPrecio(precio);
          }),
      padding: const EdgeInsets.all(16),
    );
  }
}
