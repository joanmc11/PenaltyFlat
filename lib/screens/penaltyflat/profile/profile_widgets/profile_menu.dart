import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';


class ProfileMenu extends StatelessWidget {
   final String text; 
   final IconData icon;
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

 
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: PageColors.blue,
          padding: EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor:PageColors.yellow.withOpacity(0),
          side: BorderSide(color: PageColors.blue.withOpacity(0.2))
        ),
        onPressed: press,
        child: Row(
          children: [
           Icon(icon),
            SizedBox(width: 20),
            Expanded(child: Text(text)),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}