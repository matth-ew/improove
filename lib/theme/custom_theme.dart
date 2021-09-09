import 'package:flutter/material.dart';

// const kBackgroundColor = Color(0xFFF8F8F8);
const kBackgroundColor = Color(0xFFFFFFFF);
const kActiveIconColor = Color(0xFFE68342);
const kTextColor = Color(0xFF373856);
const kGrayColor = Color(0xFF5c5c5c);
const kBlueLightColor = Color(0xFFC7B8F5);
const kBlueColor = Color(0xFF373856);
const kShadowColor = Color(0xFFE6E6E6);

class CustomTheme {
  static ThemeData get lightTheme {
    //1
    return ThemeData(
        fontFamily: "Cairo",
        backgroundColor: kBackgroundColor,
        scaffoldBackgroundColor: kBackgroundColor,
        textTheme: ThemeData.light().textTheme.apply(displayColor: kTextColor),
        colorScheme: const ColorScheme.light().copyWith(
          primary: kBlueColor,
          // primaryVariant: primaryVariant,
          // secondary: secondary,
          // secondaryVariant: secondaryVariant,
          // surface: surface,
          // background: background,
          // error: error,
          onPrimary: kBackgroundColor,
          // onSecondary: onSecondary,
          onSurface: kGrayColor,
          // onBackground: onBackground,
          // onError: onError,
          // brightness: brightness,
        ),
        //2
        primaryColor: kBlueColor,
        buttonTheme: ButtonThemeData(
          // 4
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: kBlueColor,
        ));
  }

  static ThemeData get darkTheme {
    return ThemeData(
        fontFamily: "Cairo",
        backgroundColor: kBackgroundColor,
        scaffoldBackgroundColor: kBackgroundColor,
        textTheme: ThemeData.dark().textTheme.apply(displayColor: kTextColor),
        colorScheme: const ColorScheme.dark().copyWith(
          primary: Colors.white,
          // primaryVariant: primaryVariant,
          // secondary: secondary,
          // secondaryVariant: secondaryVariant,
          // surface: surface,
          // background: background,
          // error: error,
          // onPrimary: onPrimary,
          // onSecondary: onSecondary,
          // onSurface: onSurface,
          // onBackground: onBackground,
          // onError: onError,
          // brightness: brightness,
        ),
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
