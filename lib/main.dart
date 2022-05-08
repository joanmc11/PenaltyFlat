// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:penalty_flat_app/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:penalty_flat_app/services/auth.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  await Firebase.initializeApp();
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      value: AuthService().user,
      initialData: null,
      // ignore: avoid_types_as_parameter_names
      catchError: (User, MyUser) => null,
      child: ChangeNotifierProvider(
        create: (_)=>SesionProvider(),
        child: const MaterialApp(
          home: Wrapper(),
        ),
      ),
    );
  }
}
