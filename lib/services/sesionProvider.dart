// ignore_for_file: file_names

import 'package:flutter/material.dart';

class SesionProvider extends ChangeNotifier{
  
  String sesionCode="unknown" ;

  setSesion(String sesion) {
    sesionCode=sesion;
 
  }

  
  
}
