import 'package:flutter/material.dart';
import 'package:penalty_flat_app/components/app_bar/penalty_flat_app_bar.dart';
import 'package:penalty_flat_app/components/confirmaciones/cantidad_pago.dart';
import 'package:penalty_flat_app/components/confirmaciones/confirmar_pago.dart';
import 'package:penalty_flat_app/components/confirmaciones/imagen_confirmacion.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:penalty_flat_app/shared/loading.dart';
import 'package:provider/provider.dart';

class Confirmaciones extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    return Scaffold(
      appBar: PenaltyFlatAppBar(sesionId: sesionId),
      body: user == null
          ? const Loading()
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImagenConfirmacion(sesionId: sesionId, userId: userId),
                CantidadConfirmacion(sesionId: sesionId, userId: userId),
                BotonesConfirmacion(
                    sesionId: sesionId, notifyId: notifyId, userId: userId),
              ],
            ),
    );
  }
}
