import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:improove/screens/authentication_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:improove/screens/nav_screen.dart';
import 'package:improove/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

const isOnboardingFinished = 'isOnboardingFinished';

class _SplashScreenState extends State<SplashScreen> {
  late Timer timer;
  bool isLoading = true;

  @override
  void initState() {
    _checkIfFirstOpen();
    super.initState();
  }

  Future<void> _checkIfFirstOpen() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken =
        await const FlutterSecureStorage().read(key: "accessToken");
    final hasOpened = prefs.getBool(isOnboardingFinished) ?? false;

    if (!hasOpened) {
      setState(() {
        isLoading = false;
      });
    } else if (accessToken == null) {
      _goToAuthScreen();
    } else {
      _goToNavScreen();
    }
  }

  void _goToAuthScreen() {
    Navigator.of(context).pushReplacement(
      // this is route builder without any animation
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            const AuthenticationScreen(),
      ),
    );
  }

  void _goToNavScreen() {
    Navigator.of(context).pushReplacement(
      // this is route builder without any animation
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => const NavScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return isLoading
        ? Container(color: colorScheme.background)
        : const OnboardingScreen();
  }
}
