import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:improove/screens/nav_screen.dart';
import 'package:improove/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
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
    final hasOpened = prefs.getBool(isOnboardingFinished) ?? false;

    if (hasOpened) {
      _changePage();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _changePage() {
    Navigator.of(context).pushReplacement(
      // this is route builder without any animation
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => NavScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return isLoading
        ? Container(color: colorScheme.background)
        : OnboardingScreen();
  }
}
