import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/components/bottom_bar/tab_item.dart';
import 'package:penalty_flat_app/screens/profile.dart';

class BottomBarPenaltyFlat extends StatelessWidget {
  const BottomBarPenaltyFlat({
    Key? key,
    required this.sesionId,
  }) : super(key: key);

  final String sesionId;

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
                onTap: () {}, child: const TabItem(icon: Icons.home)),
            GestureDetector(
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(sesionId: sesionId)),
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