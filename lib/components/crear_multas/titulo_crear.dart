import 'package:flutter/material.dart';

import '../../../Styles/colors.dart';

class TituloCrear extends StatefulWidget {
  final Function callbackTitulo;
  const TituloCrear({
    Key? key,
    required this.callbackTitulo,
  }) : super(key: key);

  @override
  _TituloCrearState createState() => _TituloCrearState();
}

class _TituloCrearState extends State<TituloCrear> {
  String titulo = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 0.0, bottom: 4),
            child: Text(
              "Ponle un título a tu norma:",
              style: TiposBlue.body,
            ),
          ),
        ),
        TextFormField(
          //email
          validator: (val) => val!.isEmpty ? "Introduce un nombre para la norma" : null,
          decoration: InputDecoration(
              hintText: "Titulo ",
              focusedBorder:
                  OutlineInputBorder(borderSide: BorderSide(color: PageColors.yellow, width: 0.5))),
          onChanged: (val) {
            setState(() {
              titulo = val;
            });
            widget.callbackTitulo(titulo);
          },
        ),
      ],
    );
  }
}
