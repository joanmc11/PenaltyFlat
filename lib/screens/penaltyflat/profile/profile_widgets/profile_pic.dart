import 'package:flutter/material.dart';

import '../../../../Styles/colors.dart';


class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          const CircleAvatar(
            backgroundColor: Colors.blue,
          ),
          Positioned(
            right: -5,
            bottom: 0,
            child: SizedBox(
              height: 36,
              width: 36,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: PageColors.blue),
                  ),
                  primary: PageColors.yellow,
                  backgroundColor: PageColors.blue,
                ),
                onPressed: () {},
                child: const Text("+"),
              ),
            ),
          )
        ],
      ),
    );
  }
}