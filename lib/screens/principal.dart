import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/components/penalty_flat_app_bar.dart';
import 'package:penalty_flat_app/components/principal/miniLista_multas.dart';
import 'package:penalty_flat_app/screens/multar/usuario_multa.dart';
import 'package:penalty_flat_app/screens/profile.dart';

import '../components/principal/codigoButton.dart';
import '../components/principal/codigoCasa.dart';
import '../components/principal/estadisticas_simples.dart';
import 'bottomBar/widgets/tab_item.dart';

class PrincipalScreen extends StatelessWidget {
  final String sesionId;
  const PrincipalScreen({Key? key, required this.sesionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PenaltyFlatAppBar(sesionId: sesionId),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          EstadisticasSimples(sesionId: sesionId),
          CodigoCasa(sesionId: sesionId),
          MiniLista(sesionId: sesionId),
          CodigoButton(sesionId: sesionId)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => PersonaMultada(sesionId: sesionId)),
          );
        },
        child: Icon(
          Icons.gavel,
          color: PageColors.yellow,
        ),
        backgroundColor: PageColors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomTab(context),
    );
  }

  _buildBottomTab(context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      child: BottomAppBar(
        color: PageColors.blue,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(onTap: () {}, child: const TabItem(icon: Icons.home)),
            GestureDetector(
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ProfilePage(sesionId: sesionId)),
                );
              },
              child: const TabItem(icon: Icons.account_circle),
            )
          ],
        ),
      ),
    );
  }
}
