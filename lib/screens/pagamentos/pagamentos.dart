import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/components/app_bar/penalty_flat_app_bar.dart';
import 'package:penalty_flat_app/components/pagamentos/botones_pagamento.dart';
import 'package:penalty_flat_app/components/pagamentos/circulo_porcentaje.dart';
import 'package:penalty_flat_app/components/pagamentos/dinero_pagar.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:penalty_flat_app/models/usersInside.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:penalty_flat_app/shared/loading.dart';
import 'package:provider/provider.dart';

class Pagamento extends StatelessWidget {
  const Pagamento({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;
    return user == null
        ? const Loading()
        : Scaffold(
            appBar: PenaltyFlatAppBar(),
            body: StreamBuilder(
              stream: singleUserData(idCasa, user.uid),
              builder: (
                BuildContext context,
                AsyncSnapshot<InsideUser> snapshot,
              ) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.done:
                    throw "Stream is none or done!!!";
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.active:
                    final userData = snapshot.data!;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DineroPagamento(
                          userData: userData,
                        ),
                        CirculoPagamento(
                          userMoney: userData.dinero,
                        ),
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
                        BotonesPagamento(
                          singleUserData: userData,
                        ),
                      ],
                    );
                }
              },
            ),
          );
  }
}
