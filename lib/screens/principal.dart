import 'package:flutter/material.dart';
import 'package:penalty_flat_app/components/principal/miniLista_multas.dart';
import '../components/principal/codigoButton.dart';
import '../components/principal/codigoCasa.dart';
import '../components/principal/estadisticas_simples.dart';
class PrincipalScreen extends StatelessWidget {
  final String sesionId;
  const PrincipalScreen({Key? key, required this.sesionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          EstadisticasSimples(sesionId: sesionId),
          CodigoCasa(sesionId: sesionId),
          MiniLista(sesionId: sesionId),
          CodigoButton(sesionId: sesionId)
        ],
      
    );
  }
}
  


