import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/components/app_bar_title.dart';
import 'package:penalty_flat_app/components/multar/user_grid.dart';
import 'package:penalty_flat_app/screens/principal.dart';
import 'package:penalty_flat_app/screens/profile.dart';
import 'package:penalty_flat_app/shared/loading.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../bottomBar/widgets/tab_item.dart';
import '../notifications.dart';

class PersonaMultada extends StatelessWidget {
  final String sesionId;
  const PersonaMultada({Key? key, required this.sesionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final user = Provider.of<MyUser?>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: PageColors.blue,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        toolbarHeight: 70,
        backgroundColor: Colors.white,
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
              }),
        ],
      ),
      body: user == null
          ? const Loading()
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 50.0),
                  child: Center(child: Text("¿A quién has pillado?", style: TiposBlue.title)),
                ),
                UserGrid(sesionId: sesionId)
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
                  await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrincipalScreen(sesionId: sesionId),
                      ));
                },
                child: const TabItem(icon: Icons.home)),
            GestureDetector(
                onTap: () async {
                  await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => ProfilePage(sesionId: sesionId)),
                    ),
                  );
                },
                child: const TabItem(icon: Icons.account_circle))
          ],
        ),
      ),
    );
  }
}
