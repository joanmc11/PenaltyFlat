import 'package:flutter/material.dart';
import 'package:penalty_flat_app/components/principal/miniLista_multas.dart';
import '../components/principal/codigoButton.dart';
import '../components/principal/codigoCasa.dart';
import '../components/principal/estadisticas_simples.dart';

class PrincipalScreen extends StatelessWidget {
  const PrincipalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:  const [
        EstadisticasSimples(),
        CodigoCasa(),
        MiniLista(),
        CodigoButton(),
      ],
    );
  }
}
