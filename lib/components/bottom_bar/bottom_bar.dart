import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/components/bottom_bar/tab_item.dart';

class BottomBarPenaltyFlat extends StatelessWidget {
  const BottomBarPenaltyFlat({
    Key? key,
    required this.callbackTap,
    required this.callbackSelected,
    required this.casa,
    required this.perfil,
  }) : super(key: key);

  final Function callbackTap;
  final Function callbackSelected;
  final bool casa;
  final bool perfil;

  @override
  Widget build(BuildContext context) {
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
                  callbackTap(0);
                  callbackSelected(true, false, false);
                },
                child: TabItem(
                  icon: Icons.home,
                  currentItem: casa,
                )),
            GestureDetector(
              onTap: () async {
                callbackTap(2);
                callbackSelected(false, false, true);
              },
              child: TabItem(
                icon: Icons.account_circle,
                currentItem: perfil,
              ),
            )
          ],
        ),
      ),
    );
  }
}
