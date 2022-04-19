import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/components/app_bar/penalty_flat_app_bar.dart';
import 'package:penalty_flat_app/components/pagamentos/botones_pagamento.dart';
import 'package:penalty_flat_app/components/pagamentos/circulo_porcentaje.dart';
import 'package:penalty_flat_app/components/pagamentos/dinero_pagar.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:penalty_flat_app/shared/loading.dart';
import 'package:provider/provider.dart';

class Pagamento extends StatelessWidget {
  final String sesionId;
  const Pagamento({Key? key, required this.sesionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return user == null
        ? const Loading()
        : Scaffold(
            appBar: PenaltyFlatAppBar(sesionId: sesionId),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DineroPagamento(sesionId: sesionId),
                CirculoPagamento(sesionId: sesionId),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: Text(
                      "Este pago es simulado. Podeis acumular el dinero de la forma que prefirais",
                      style: TiposBlue.body,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                BotonesPagamento(sesionId: sesionId),
              ],
            ),
          );
  }
}
