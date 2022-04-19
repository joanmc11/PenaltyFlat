
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/components/confirmaciones/cantidad_pago.dart';
import 'package:penalty_flat_app/components/confirmaciones/confirmar_pago.dart';
import 'package:penalty_flat_app/components/confirmaciones/imagen_confirmacion.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:penalty_flat_app/shared/loading.dart';
import 'package:provider/provider.dart';

class Confirmaciones extends StatefulWidget {
  final String sesionId;
  final String notifyId;
  final String userId;
  const Confirmaciones({
    Key? key,
    required this.sesionId,
    required this.notifyId,
    required this.userId,
  }) : super(key: key);

  @override
  State<Confirmaciones> createState() => _ConfirmacionesState();
}

final List<Color> colors = [
  Colors.blue,
  Colors.red,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.pink,
  Colors.indigo,
  Colors.pinkAccent,
  Colors.amber,
  Colors.deepOrange,
  Colors.brown,
  Colors.cyan,
  Colors.yellow,
];

DateTime dateToday = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    DateTime.now().hour,
    DateTime.now().minute,
    DateTime.now().second);

class _ConfirmacionesState extends State<Confirmaciones> {
  bool pagado = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: PageColors.blue,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/LogoCabecera.png',
                height: 80,
                width: 80,
              ),
              Text('PENALTY FLAT',
                  style: TextStyle(
                      fontFamily: 'BasierCircle',
                      fontSize: 18,
                      color: PageColors.blue,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
      body: user == null
          ? const Loading()
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImagenConfirmacion(
                    sesionId: widget.sesionId, userId: widget.userId),
                CantidadConfirmacion(
                    sesionId: widget.sesionId, userId: widget.userId),
                BotonesConfirmacion(
                    sesionId: widget.sesionId,
                    notifyId: widget.notifyId,
                    userId: widget.userId),
              ],
            ),
    );
  }
}
