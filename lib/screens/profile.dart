import 'package:flutter/material.dart';
import 'package:penalty_flat_app/components/profile_widgets/profile_menu.dart';
import 'package:penalty_flat_app/components/profile_widgets/profile_pic.dart';
import 'package:penalty_flat_app/main.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:penalty_flat_app/models/usersInside.dart';
import 'package:penalty_flat_app/screens/pagamentos/pagamentos.dart';
import 'package:penalty_flat_app/services/sesionProvider.dart';
import 'package:penalty_flat_app/shared/loading.dart';
import 'package:provider/provider.dart';
import '../../services/auth.dart';
import 'pagamentos/pagamentos.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);
  final AuthService _auth = AuthService();
  

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    final idCasa = Provider.of<SesionProvider?>(context)!.sesionCode;
    return user == null
        ? const Loading()
        : StreamBuilder(
            stream: singleUserData(idCasa, user.uid),
            builder: (
              BuildContext context,
              AsyncSnapshot<InsideUser> snapshot,
            ) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.done:
                  throw "Stream is none or done!!!";
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                  final userData = snapshot.data!;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: ProfilePic(
                          userData: userData,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ProfileMenu(
                        text: "Mis PenaltyFlats",
                        icon: Icons.house_siding_rounded,
                        press: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyApp(showHome: true,),
                              ));
                        },
                      ),
                      ProfileMenu(
                        text: "Paga tus multas",
                        icon: Icons.payment,
                        press: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Pagamento(),
                              ));
                        },
                      ),
                      ProfileMenu(
                        text: "Abandonar la casa",
                        icon: Icons.cancel_sharp,
                        press: () {},
                      ),
                      ProfileMenu(
                        text: "Log Out",
                        icon: Icons.logout,
                        press: () async {
                          await _auth.signOut();
                          await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyApp(showHome: true,),
                              ));
                        },
                      ),
                    ],
                  );
              }
            },
          );
  }
}
