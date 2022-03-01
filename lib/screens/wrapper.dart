import 'package:flutter/material.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:penalty_flat_app/screens/authenticate/authenticate.dart';
import 'package:penalty_flat_app/screens/inside/inici.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final user = Provider.of<MyUser?>(context);
    print(user);
    
    
    //Retorna home o authenticate widged depenent de si estàs logejat o no
    if(user== null){
      return const Authenticate();
    }
    else{
      return Inicio();
    }
  }
}