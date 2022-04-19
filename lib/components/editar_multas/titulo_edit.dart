// ignore_for_file: deprecated_member_use


import 'package:flutter/material.dart';
import 'package:string_extensions/string_extensions.dart';
import '../../../Styles/colors.dart';

class TituloEdit extends StatefulWidget {
  
  final String titulo;
  final Function callbackTitulo;
  const TituloEdit(
      {Key? key,
      
      required this.titulo,
      required this.callbackTitulo
      })
      : super(key: key);

  @override
  _TituloEditState createState() => _TituloEditState();
}

class _TituloEditState extends State<TituloEdit> {
  @override
  void initState() {
    super.initState();
    setState(() {
      titulo = widget.titulo;
    });
  }

  

  String titulo = "";
 
  bool editTit = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 0.0, bottom: 4),
            child: Text(
              "Título:",
              style: TiposBlue.body,
            ),
          ),
        ),
        editTit
            ? TextFormField(
                validator: (val) => val!.isEmpty
                    ? "Introduce un nombre para la norma"
                    : null,
                initialValue: titulo.capitalize,
                decoration: InputDecoration(
                    hintText: "Titulo ",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: PageColors.yellow,
                            width: 0.5))),
                onChanged: (val) {
                  setState(() {
                    titulo = val;
                  });
                  widget.callbackTitulo(titulo);
                },
              )
            : Row(
                children: [
                  Flexible(
                      child: Text(
                    widget.titulo.capitalize!,
                    style: TiposBlue.bodyBold,
                  )),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16.0),
                    child: GestureDetector(
                        onTap: () {
                          setState(() {
                            editTit = true;
                          });
                          
                        },
                        child: Icon(
                          Icons.edit,
                          color: PageColors.blue,
                        )),
                  )
                ],
              ),
      ],
    );
  }
}
