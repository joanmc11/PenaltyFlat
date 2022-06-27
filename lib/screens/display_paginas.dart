import 'package:flutter/material.dart';
import 'package:penalty_flat_app/components/app_bar/penalty_flat_app_bar.dart';
import 'package:penalty_flat_app/components/bottom_bar/bottom_bar.dart';
import 'package:penalty_flat_app/components/bottom_bar/button_penalty.dart';
import 'package:penalty_flat_app/screens/multar/usuario_multa.dart';
import 'package:penalty_flat_app/screens/principal.dart';
import 'package:penalty_flat_app/screens/profile.dart';

class DisplayPaginas extends StatefulWidget {
  const DisplayPaginas({Key? key}) : super(key: key);

  @override
  State<DisplayPaginas> createState() => _DisplayPaginasState();
}

int _selectedIndex = 0;
bool casa = true;
bool multa = false;
bool perfil = false;

class _DisplayPaginasState extends State<DisplayPaginas> {
  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedIndex = 0;
      casa = true;
      multa = false;
      perfil = false;
    });
  }

  callbackTap(varIndex) {
    setState(() {
      _selectedIndex = varIndex;
    });
  }

  callbackSelected(varCasa, varMulta, varPerfil) {
    setState(() {
      casa = varCasa;
      multa = varMulta;
      perfil = varPerfil;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = <Widget>[
      const PrincipalScreen(),
      const PersonaMultada(),
            ProfilePage(),
    ];

    return Scaffold(
      appBar: PenaltyFlatAppBar(),
      body: _pages.elementAt(_selectedIndex),
      floatingActionButton: BottomBarButtonPenalty(
        callbackTap: callbackTap,
        callbackSelected: callbackSelected,
        multa: multa,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomTab(context),
    );
  }

  _buildBottomTab(context) {
    return BottomBarPenaltyFlat(
      callbackTap: callbackTap,
      callbackSelected: callbackSelected,
      casa: casa,
      perfil: perfil,
    );
  }
}
