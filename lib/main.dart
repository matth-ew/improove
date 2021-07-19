import 'package:flutter/material.dart';
import 'package:improove_flutter/screens/nav_screen.dart';
import 'package:improove_flutter/theme/custom_theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Improove',
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      home: NavScreen(),
    );
  }
}
