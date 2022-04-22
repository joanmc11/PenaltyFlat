import 'package:flutter/material.dart';
import 'package:penalty_flat_app/components/bottom_bar/bottom_bar.dart';
import 'package:penalty_flat_app/components/bottom_bar/button_penalty.dart';
import 'package:penalty_flat_app/screens/multar/usuario_multa.dart';
import 'package:penalty_flat_app/screens/principal.dart';
import 'package:penalty_flat_app/screens/profile.dart';
import '../components/app_bar/penalty_flat_app_bar.dart';

class DisplayPaginas extends StatefulWidget {
  final String sesionId;
  const DisplayPaginas({Key? key, required this.sesionId}) : super(key: key);

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
      PrincipalScreen(sesionId: widget.sesionId),
      PersonaMultada(sesionId: widget.sesionId),
      ProfilePage(sesionId: widget.sesionId),
    ];

    return Scaffold(
      appBar: PenaltyFlatAppBar(sesionId: widget.sesionId),
      body: _pages.elementAt(_selectedIndex),
      floatingActionButton: BottomBarButtonPenalty(
          sesionId: widget.sesionId,
          callbackTap: callbackTap,
          callbackSelected: callbackSelected,
          multa: multa),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomTab(context),
    );
  }

  _buildBottomTab(context) {
    return BottomBarPenaltyFlat(
      sesionId: widget.sesionId,
      callbackTap: callbackTap,
      callbackSelected: callbackSelected,
      casa: casa,
      perfil: perfil,
    );
  }
}
