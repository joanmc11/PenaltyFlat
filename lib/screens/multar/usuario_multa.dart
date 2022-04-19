
import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/components/app_bar/penalty_flat_app_bar.dart';
import 'package:penalty_flat_app/components/bottom_bar/bottom_bar.dart';
import 'package:penalty_flat_app/components/bottom_bar/button_penalty.dart';
import 'package:penalty_flat_app/components/multar/user_grid.dart';
import 'package:penalty_flat_app/shared/loading.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';

class PersonaMultada extends StatelessWidget {
  final String sesionId;
  const PersonaMultada({Key? key, required this.sesionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   
    final user = Provider.of<MyUser?>(context);
    return Scaffold(
      appBar: PenaltyFlatAppBar(sesionId: sesionId),
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
      floatingActionButton: BottomBarButtonPenalty(sesionId: sesionId),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomTab(context),
    );
  }

  _buildBottomTab(context) {
    return BottomBarPenaltyFlat(sesionId: sesionId);
  }
}
