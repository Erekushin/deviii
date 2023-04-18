import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';

class Themes {
  /// light theme
  static final light = ThemeData.light().copyWith(
    backgroundColor: Colors.white,

    /// Button style theme
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: const BorderSide(color: Colors.red),
      ),
    ),

    /// input style theme
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.black,
      filled: true,
      contentPadding: const EdgeInsets.all(12),
      hintStyle: const TextStyle(
        color: Colors.white,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(color: CoreColor().appGreen, width: 1.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(color: CoreColor().appGreen, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(color: CoreColor().appGreen, width: 1.0),
      ),
    ),
  );

  /// dark theme

  static final dark = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    // backgroundColor: CoreColor().appbarColor,
    // appBarTheme: AppBarTheme(
    //   backgroundColor: CoreColor().appbarColor,
    //   // color: Colors.red,
    // ),
    //text theme style
    textTheme: TextTheme(
      headline1: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      headline2: TextStyle(
        color: CoreColor().appGreen,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
      bodyText1: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      bodyText2: TextStyle(
        color: CoreColor().appGreen,
        fontSize: 12,
      ),
      button: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
    ),

    /// Button style theme
    buttonTheme: ButtonThemeData(
      height: 50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
          color: CoreColor().appGreen,
        ),
      ),
      buttonColor:
          CoreColor().appGreen, // Background color (orange in my case).
    ),

    iconTheme: IconThemeData(
      color: CoreColor().appGreen,
    ),

    /// input style theme
    inputDecorationTheme: InputDecorationTheme(
      fillColor: CoreColor().grey,
      filled: true,
      contentPadding: const EdgeInsets.all(12),
      hintStyle:
          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(color: CoreColor().appGreen, width: 1.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(color: CoreColor().appGreen, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(color: CoreColor().appGreen, width: 1.0),
      ),
    ),
  );
}
