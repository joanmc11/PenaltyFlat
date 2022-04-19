import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/components/app_bar_title.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:penalty_flat_app/screens/multar/usuario_multa.dart';
import 'package:penalty_flat_app/screens/principal.dart';
import 'package:penalty_flat_app/screens/profile.dart';
import 'package:provider/provider.dart';
import '../components/stats/general_stats.dart';
import '../components/stats/own_stats.dart';
import 'bottomBar/widgets/tab_item.dart';
import 'notifications.dart';

class EstadisticaMultas extends StatelessWidget {
  final String sesionId;
  const EstadisticaMultas({Key? key, required this.sesionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final user = Provider.of<MyUser?>(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: PageColors.blue,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const AppBarTitle(),
        actions: <Widget>[
          StreamBuilder(
            stream: db
                .collection("sesion/$sesionId/notificaciones")
                .where('idUsuario', isEqualTo: user?.uid)
                .where('visto', isEqualTo: false)
                .snapshots(),
            builder: (
              BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
            ) {
              if (snapshot.hasError) {
                return ErrorWidget(snapshot.error.toString());
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final notifyData = snapshot.data!.docs;

              return IconBadge(
                icon: Icon(
                  Icons.notifications_none_outlined,
                  color: PageColors.blue,
                  size: 35,
                ),
                itemCount: notifyData.length,
                badgeColor: Colors.red,
                itemColor: Colors.white,
                hideZero: true,
                top: 11,
                right: 9,
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Notificaciones(sesionId: sesionId)),
                  );
                },
              );
            },
          ),
        ],
      ),
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
