import 'package:flutter/material.dart';
import 'package:penalty_flat_app/models/codigo_multas.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:provider/provider.dart';

class TestListMultasPage extends StatelessWidget {
  const TestListMultasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;
    final idCasa = context.read<SesionProvider?>()!.sesionCode;
    return StreamBuilder(
      stream: codigoMultasSnapshots(idCasa),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<CodigoMultas>> snapshot,
      ) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.done:
            throw "Stream is none or done!!!";
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
            final listCodigoMultas = snapshot.data!;
            return _Llista(listCodigoMultas: listCodigoMultas);
        }
      },
    );
  }
}

class _Llista extends StatelessWidget {
  const _Llista({
    Key? key,
    required this.listCodigoMultas,
  }) : super(key: key);

  final List<CodigoMultas> listCodigoMultas;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listCodigoMultas.length,
      itemBuilder: (BuildContext context, int index) {
        final multa = listCodigoMultas[index];
        return ListTile(
          title: Text(multa.titulo),
          subtitle: Text(multa.descripcion),
        );
      },
    );
  }
}
