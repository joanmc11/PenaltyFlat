
import 'package:flutter/material.dart';
import 'package:string_extensions/string_extensions.dart';
import '../../../Styles/colors.dart';

class DescripcionEdit extends StatefulWidget {
    final String descripcion;
  final Function callbackDesc;
  const DescripcionEdit({
    Key? key,
    
    required this.descripcion,
    required this.callbackDesc,
  }) : super(key: key);

  @override
  _DescripcionEditState createState() => _DescripcionEditState();
}

class _DescripcionEditState extends State<DescripcionEdit> {
  @override
  void initState() {
    super.initState();
    setState(() {
      descripcion = widget.descripcion;
    });
  }


  String descripcion = "";
  bool editDesc = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 0, bottom: 4),
            child: Text(
              "Descripción:",
              style: TiposBlue.body,
            ),
          ),
        ),
        editDesc
            ? TextFormField(
                validator: (val) =>
                    val!.isEmpty ? "Añade una descripción" : null,
                initialValue: descripcion.capitalize,
                decoration: InputDecoration(
                    hintText: "Descripción ",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: PageColors.yellow, width: 0.5))),
                onChanged: (val) {
                  setState(() {
                    descripcion = val;
                  });
                  widget.callbackDesc(descripcion);
                },
              )
            : Row(
                children: [
                  Flexible(
                      child: Text(
                    widget.descripcion.capitalize!,
                    style: TiposBlue.bodyBold,
                  )),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: GestureDetector(
                        onTap: () {
                          setState(() {
                            editDesc = true;
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
