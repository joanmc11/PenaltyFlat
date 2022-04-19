import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../Styles/colors.dart';

class DescripcionCrear extends StatefulWidget {
  final String sesionId;
  final Function callbackDesc;
  const DescripcionCrear({
    Key? key,
    required this.sesionId,
    required this.callbackDesc,
  }) : super(key: key);

  @override
  _DescripcionCrearState createState() => _DescripcionCrearState();
}

class _DescripcionCrearState extends State<DescripcionCrear> {
  final db = FirebaseFirestore.instance;
  
  String descripcion = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 0, bottom: 4),
            child: Text(
              "Descríbela brevemente:",
              style: TiposBlue.body,
            ),
          ),
        ),
        TextFormField(
          validator: (val) => val!.isEmpty
              ? "Añade una pequeña descripción"
              : null,
          decoration: InputDecoration(
              hintText: "Descripción ",
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: PageColors.yellow,
                      width: 0.5))),
          onChanged: (val) {
            setState(() {
              descripcion = val;
            });
            widget.callbackDesc(descripcion);
          },
        ),
      ],
    );
  }
}
