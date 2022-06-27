import 'package:flutter/material.dart';
import 'package:penalty_flat_app/Styles/colors.dart';
import 'package:penalty_flat_app/screens/wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              isLastPage = index == 3;
            });
          },
          children: const [
            OnboardPageBuilder(
              title: "Bienvenido a PenaltyFlat",
              imageUrl: 'assets/images/onboarding_1.png',
              subtitle:
                  "Asegurate de que la higiene de tu casa esté en harmonía.",
            ),
            OnboardPageBuilder(
              title: "Acusa y multa",
              imageUrl: 'assets/images/onboarding_2.png',
              subtitle:
                  "Acusa y multa a tus compañeros de piso si no cumplen las normas del hogar.",
            ),
            OnboardPageBuilder(
              title: "Convive y recauda",
              imageUrl: 'assets/images/onboarding_3.png',
              subtitle:
                  "Mejora la convivencia a la vez que recaudas dinero para tu hogar.",
            ),
            OnboardPageBuilder(
              title: "¿A qué esperas?",
              imageUrl: 'assets/images/onboarding_4.png',
              subtitle: "Reta a tus compañeros mejorando vuestra convivencia.",
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? Container(
            color: const Color.fromRGBO(245, 245, 237, 1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:20, vertical: 10),
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),
                  ),
                  primary: PageColors.yellow,
                  backgroundColor: PageColors.yellow,
                  minimumSize: const Size.fromHeight(70)
                ),
                  onPressed: () async{
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool('showHome', true);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context)=>const Wrapper())
                    );
                  },
                  child: Text(
                    'Empezar',
                    style: TiposBlue.bodyBold,
                    textScaleFactor: 1.2,
                  ),
                ),
            ),
          )
          : Container(
              color: const Color.fromRGBO(245, 245, 237, 1),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: (() {
                        controller.jumpToPage(3);
                      }),
                      child: Text(
                        'Saltar',
                        style: TextStyle(color: PageColors.blue),
                      )),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 4,
                      effect: WormEffect(
                        spacing: 16,
                        dotColor: Colors.grey,
                        activeDotColor: PageColors.blue,
                        dotHeight: 10,
                        dotWidth: 10,
                      ),
                      onDotClicked: (index) => controller.animateToPage(index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut),
                    ),
                  ),
                  TextButton(
                      onPressed: (() {
                        controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      }),
                      child: Text(
                        'Siguiente',
                        style: TextStyle(color: PageColors.blue),
                      ))
                ],
              ),
            ),
    );
  }
}

class OnboardPageBuilder extends StatelessWidget {
  const OnboardPageBuilder(
      {Key? key,
      required this.title,
      required this.imageUrl,
      required this.subtitle})
      : super(key: key);
  final String title;
  final String imageUrl;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(245, 245, 237, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: SizedBox(
              height: 100,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: TiposBlue.titleBold,
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.05,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              imageUrl,
              fit: BoxFit.fitHeight,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: SizedBox(
              height: 80,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  subtitle,
                  style: TiposBlue.subtitle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
