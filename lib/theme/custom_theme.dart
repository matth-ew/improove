import 'package:flutter/material.dart';
import 'colors.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    //1
    return ThemeData(
        fontFamily: "Cairo",
        scaffoldBackgroundColor: kBackgroundColor,
        textTheme: ThemeData.light().textTheme.apply(displayColor: kTextColor),
        //2
        // primaryColor: CustomColors.purple,
        buttonTheme: ButtonThemeData(
          // 4
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          // buttonColor: CustomColors.lightPurple,
        ));
  }

  static ThemeData get darkTheme {
    return ThemeData(
        fontFamily: "Cairo",
        scaffoldBackgroundColor: kBackgroundColor,
        textTheme: ThemeData.light().textTheme.apply(displayColor: kTextColor),
        //2
        // primaryColor: CustomColors.purple,
        buttonTheme: ButtonThemeData(
          // 4
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          // buttonColor: CustomColors.lightPurple,
        ));
  }
}
