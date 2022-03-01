import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PageColors{


static Color yellow = const Color.fromRGBO(214, 169, 59, 1);
static Color blue = const Color.fromRGBO(45, 52, 96, 1);

static Color white = const Color.fromRGBO(255, 255, 255, 1);

static Color black = const Color.fromRGBO(50, 50, 50, 1);

  
  
}

class TiposBlue{

  static TextStyle title = GoogleFonts.nunitoSans(fontSize: 28, textStyle: TextStyle(color: PageColors.blue, fontWeight: FontWeight.w600));
   static TextStyle subtitle = GoogleFonts.nunitoSans(fontSize: 20, textStyle: TextStyle(color: PageColors.blue, fontWeight: FontWeight.w600));
  static TextStyle body = GoogleFonts.nunitoSans(fontSize: 16, textStyle: TextStyle(color: PageColors.blue));
  static TextStyle bodyBold = GoogleFonts.nunitoSans(fontSize: 16, textStyle: TextStyle(color: PageColors.blue, fontWeight: FontWeight.bold));

}

class TiposYel{

  static TextStyle title = GoogleFonts.nunitoSans(fontSize: 28, textStyle: TextStyle(color: PageColors.yellow, fontWeight: FontWeight.w600));
   static TextStyle subtitle = GoogleFonts.nunitoSans(fontSize: 20, textStyle: TextStyle(color: PageColors.yellow, fontWeight: FontWeight.w600));
  static TextStyle body = GoogleFonts.nunitoSans(fontSize: 16, textStyle: TextStyle(color: PageColors.yellow));
  static TextStyle bodyBold = GoogleFonts.nunitoSans(fontSize: 16, textStyle: TextStyle(color: PageColors.yellow, fontWeight: FontWeight.bold));


}

