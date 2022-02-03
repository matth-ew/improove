import 'package:flutter/material.dart';
import 'package:improove/screens/authentication_screen.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  String currentText = "";

  // Future<bool> isFirstTime() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var isFirstTime = prefs.getBool('first_time');
  //   if (isFirstTime != null && !isFirstTime) {
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }

  Future<void> _setOnboardingEnd() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboardingFinished', true);
    await prefs.setString('referralCode', currentText);
  }

  // @override
  // void initState() {
  //   super.initState();

  //   isFirstTime().then((isFirstTime) {
  //     isFirstTime ? print("First time") : navigationPageHome();
  //   });
  // }

  Future<void> _onIntroEnd(BuildContext context) async {
    await _setOnboardingEnd();
    _goToAuthScreen();
  }

  void _goToAuthScreen() {
    //Navigator.of(context).pushReplacementNamed('/HomePage');
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AuthenticationScreen()));
  }

  // Widget _buildFullscrenImage() {
  //   return Image.asset(
  //     'assets/fullscreen.jpg',
  //     fit: BoxFit.cover,
  //     height: double.infinity,
  //     width: double.infinity,
  //     alignment: Alignment.center,
  //   );
  // }

  Widget _buildImage(String assetName, [double width = 350]) {
    return SvgPicture.asset(
      'assets/icons/$assetName',
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final pageDecoration = PageDecoration(
      titleTextStyle: textTheme.headline4?.copyWith(
              color: colorScheme.primary, fontWeight: FontWeight.w700) ??
          const TextStyle(),
      bodyTextStyle: textTheme.bodyText2?.copyWith(
              fontSize: 24, color: colorScheme.onBackground.withOpacity(0.7)) ??
          const TextStyle(),
      descriptionPadding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      pageColor: colorScheme.background,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: colorScheme.background,
      // globalHeader: Align(
      //   alignment: Alignment.topRight,
      //   child: SafeArea(
      //     child: Padding(
      //       padding: const EdgeInsets.only(top: 16, right: 16),
      //       child: _buildImage('flutter.png', 100),
      //     ),
      //   ),
      // ),
      pages: [
        PageViewModel(
          title: AppLocalizations.of(context)!.onboardingTitle1,
          body: AppLocalizations.of(context)!.onboardingDescription1,
          image: _buildImage('onboarding1.svg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: AppLocalizations.of(context)!.onboardingTitle2,
          body: AppLocalizations.of(context)!.onboardingDescription2,
          image: _buildImage('onboarding2.svg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: AppLocalizations.of(context)!.onboardingTitle3,
          body: AppLocalizations.of(context)!.onboardingDescription3,
          image: _buildImage('onboarding3.svg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: AppLocalizations.of(context)!.onboardingTitle4,
          bodyWidget: TextField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
              // labelText: 'Email',
              hintText: AppLocalizations.of(context)!.onboardingDescription4,
            ),
            onChanged: (value) {
              setState(() {
                currentText = value;
              });
            },
            // maxLines: 1,
            // minLines: 1,
          ),
          image: _buildImage('onboarding4.svg'),
          decoration: pageDecoration.copyWith(
              imagePadding: const EdgeInsets.symmetric(horizontal: 50)),
        ),
        // PageViewModel(
        //   title: "Full Screen Page",
        //   body:
        //       "Pages can be full screen as well.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc id euismod lectus, non tempor felis. Nam rutrum rhoncus est ac venenatis.",
        //   image: _buildFullscrenImage(),
        //   decoration: pageDecoration.copyWith(
        //     contentMargin: const EdgeInsets.symmetric(horizontal: 16),
        //     fullScreen: true,
        //     bodyFlex: 2,
        //     imageFlex: 3,
        //   ),
        // ),
        // PageViewModel(
        //   title: "Another title page",
        //   body: "Another beautiful body text for this example onboarding",
        //   image: _buildImage('img2.jpg'),
        //   footer: ElevatedButton(
        //     onPressed: () {
        //       introKey.currentState?.animateScroll(0);
        //     },
        //     child: const Text(
        //       'FooButton',
        //       style: TextStyle(color: Colors.white),
        //     ),
        //     style: ElevatedButton.styleFrom(
        //       primary: Colors.lightBlue,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(8.0),
        //       ),
        //     ),
        //   ),
        //   decoration: pageDecoration,
        // ),
        // PageViewModel(
        //   title: "Title of last page - reversed",
        //   bodyWidget: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: const [
        //       Text("Click on ", style: bodyStyle),
        //       Icon(Icons.edit),
        //       Text(" to edit a post", style: bodyStyle),
        //     ],
        //   ),
        //   decoration: pageDecoration.copyWith(
        //     bodyFlex: 2,
        //     imageFlex: 4,
        //     bodyAlignment: Alignment.bottomCenter,
        //     imageAlignment: Alignment.topCenter,
        //   ),
        //   image: _buildImage('img1.jpg'),
        //   reverse: true,
        // ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      // showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left
      // skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: Text(AppLocalizations.of(context)!.done,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: //kIsWeb ? const EdgeInsets.all(12.0) :
          const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        activeColor: colorScheme.primary,
        color: const Color(0xFFBDBDBD),
        activeSize: const Size(22.0, 10.0),
        activeShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      // dotsContainerDecorator: const ShapeDecoration(
      //   color: Colors.black87,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.all(Radius.circular(8.0)),
      //   ),
      // ),
    );
  }
}
