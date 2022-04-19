
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/components/penalty_flat_app_bar.dart';
import 'package:penalty_flat_app/screens/multar/usuario_multa.dart';
import 'package:penalty_flat_app/screens/principal.dart';
import 'package:penalty_flat_app/screens/profile.dart';
import '../components/stats/general_stats.dart';
import '../components/stats/own_stats.dart';
import 'bottomBar/widgets/tab_item.dart';

class EstadisticaMultas extends StatelessWidget {
  final String sesionId;
  const EstadisticaMultas({Key? key, required this.sesionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: PenaltyFlatAppBar(sesionId: sesionId),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Estadisticas generales:",
            style: TiposBlue.subtitle,
          ),
          GeneralStats(sesionId: sesionId),
          Text(
            "Estadisticas propias:",
            style: TiposBlue.subtitle,
          ),
          OwnStats(sesionId: sesionId),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
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
            GestureDetector(
              onTap: () async {
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => PrincipalScreen(sesionId: sesionId)),
                );
              },
              child: const TabItem(icon: Icons.home),
            ),
            GestureDetector(
              onTap: () async {
                await Navigator.of(context).pushReplacement(
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
