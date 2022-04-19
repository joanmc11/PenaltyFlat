import 'package:flutter/material.dart';
import 'package:penalty_flat_app/components/bottom_bar/bottom_bar.dart';
import 'package:penalty_flat_app/components/bottom_bar/button_penalty.dart';
import 'package:penalty_flat_app/components/profile_widgets/profile_menu.dart';
import 'package:penalty_flat_app/components/profile_widgets/profile_pic.dart';
import 'package:penalty_flat_app/main.dart';
import 'package:penalty_flat_app/screens/pagamentos/pagamentos.dart';
import '../../services/auth.dart';
import 'pagamentos/pagamentos.dart';

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
          Padding(
            padding: const EdgeInsets.only(top:18.0),
            child: ProfilePic(sesionId: sesionId),
          ),
          const SizedBox(height: 20),
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
            text: "Paga tus multas",
            icon: Icons.payment,
            press: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Pagamento(sesionId: sesionId,),
                  ));
            },
          ),
          
          ProfileMenu(
            text: "Abandonar la casa",
            icon: Icons.cancel_sharp,
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
      floatingActionButton: BottomBarButtonPenalty(sesionId: sesionId),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomTab(context),
    );
  }

  _buildBottomTab(context) {
    return BottomBarPenaltyFlat(sesionId: sesionId);
  }
}


