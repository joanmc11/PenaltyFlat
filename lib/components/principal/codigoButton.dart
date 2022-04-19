
// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import '../../screens/codigo_multas.dart';

class CodigoButton extends StatelessWidget {
  final String sesionId;
  const CodigoButton({Key? key, required this.sesionId}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.only(bottom: 30.0, top: 10),
        child: ElevatedButton(
          style: TextButton.styleFrom(
              primary: PageColors.blue,
              backgroundColor: PageColors.yellow,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              minimumSize: const Size(200, 50)),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => CodigoMultas(sesionId: sesionId)),
            );
          },
          child: const Text('Código de Multas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ),
      );
  }
}
