import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';


class MultadoPage extends StatelessWidget {
  final String nombre;
  const MultadoPage({ Key? key, required this.nombre }) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(backgroundColor: PageColors.yellow, body: Center(child: Text("""¡Se ha enviado la multa a
      $nombre!""", style: TiposBlue.title,)),
      
    );
  }
}