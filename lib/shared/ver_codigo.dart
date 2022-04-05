import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';

class VerCodigo extends StatelessWidget {
  final String casa;
  final String codigo;
  const VerCodigo({Key? key, required this.casa, required this.codigo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PageColors.yellow,
      body: Column(
         mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Center(
                    child: Text(
                      "El código para unirse a $casa es:",
                      style: TiposBlue.subtitle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16.0, bottom: 16, left: 32, right: 32),
                  child: DottedBorder(
                    radius: const Radius.circular(8),
                    borderType: BorderType.RRect,
                    dashPattern: const [5],
                    color: PageColors.blue,
                    strokeWidth: 0.5,
                    child: Center(
                        child: Text(codigo,
                            style: TextStyle(fontSize: 80, color: PageColors.blue))),
                  ),
                ),
                
              ],
            ),
          ),
          Expanded(
            
            flex: 1,
            child: Align(
                  alignment: Alignment.topCenter,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(PageColors.blue)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Volver", style: TiposYel.bodyBold,),
                ),
          ),),
        ],
      ),
    );
  }
}
