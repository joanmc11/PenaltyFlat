import 'package:flutter/material.dart';
import 'package:penalty_flat_app/main.dart';
import 'package:penalty_flat_app/screens/penaltyflat/principal.dart';

import '../../../Styles/colors.dart';
import '../../../services/auth.dart';
import '../../multar/usuario_multa.dart';
import '../../widgets/tab_item.dart';
import 'profile_widgets/profile_menu.dart';
import 'profile_widgets/profile_pic.dart';

class ProfilePage extends StatelessWidget {
  final String sesionId;

  ProfilePage({
    Key? key,
    required this.sesionId,
  }) : super(key: key);
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "Mis PenaltyFlats",
            icon: Icons.house_siding_rounded,
            press: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyApp(),
                  ));
            },
          ),
          ProfileMenu(
            text: "Notificaciones",
            icon: Icons.notification_add,
            press: () {},
          ),
          ProfileMenu(
            text: "Configuración",
            icon: Icons.settings,
            press: () {},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: Icons.logout,
            press: () async {
              await _auth.signOut();
              await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyApp(),
                  ));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonaMultada(sesionId: sesionId),
              ));
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
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PrincipalScreen(sesionId: sesionId),
                      ));
                },
                child: const TabItem(icon: Icons.home)),
            GestureDetector(
                onTap: () {}, child: const TabItem(icon: Icons.account_circle))
          ],
        ),
      ),
    );
  }
}