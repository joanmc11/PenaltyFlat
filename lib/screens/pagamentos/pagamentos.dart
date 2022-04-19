
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/components/pagamentos/botones_pagamento.dart';
import 'package:penalty_flat_app/components/pagamentos/circulo_porcentaje.dart';
import 'package:penalty_flat_app/components/pagamentos/dinero_pagar.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:penalty_flat_app/shared/loading.dart';
import 'package:provider/provider.dart';

class Pagamento extends StatelessWidget {
  final String sesionId;
  Pagamento({Key? key, required this.sesionId}) : super(key: key);

  final DateTime dateToday = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    DateTime.now().hour,
    DateTime.now().minute,
    DateTime.now().second,
  );

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return user == null
        ? const Loading()
        : Scaffold(
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
              actions: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications_none_outlined,
                    color: PageColors.blue,
                  ),
                  padding: const EdgeInsets.only(right: 30),
                )
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DineroPagamento(sesionId: sesionId),
                CirculoPagamento(sesionId: sesionId),
                 Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: Text("Este pago es simulado. Podeis acumular el dinero de la forma que prefirais", style: TiposBlue.body,textAlign: TextAlign.center, ),
                  ),
                ),
                
                BotonesPagamento(sesionId: sesionId),
              ],
            ),
          );
  }
}
