// ignore_for_file: unnecessary_this

import 'package:devita/helpers/gvariables.dart';
import 'package:devita/style/color.dart';
import 'package:flutter/material.dart';

/// string extension capitalize
extension StringExtension on String {
  /// uppercase first one string
  String capitalizeCustom() {
    if (isEmpty) {
      return "";
    }
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  ///First 3 character of string
  first3() {
    return substring(0, 3);
  }

  lastSplice3() {
    return substring(0, 5);
  }

  toNormalDate() {
    return this.substring(0, 10) + ' ' + this.substring(11, 19);
  }

  coreTranslationWord() {
    return GlobalVariables.languageStatic[GlobalVariables.localeLong]?[this] ??
        "";
  }
}

extension TextStyleExtension on TextStyle {
  TextStyle bodyText1() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 14,
    );
  }
}

extension TextFormFieldEx on TextField {
  TextField devitaTextField(
      String hintText, bool icon, iconName, suffixIcon, obscureText) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon:
            icon == true ? Icon(iconName, color: CoreColor().appGreen) : null,
        hintText: hintText,
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
        suffixIcon: suffixIcon == false ? null : suffixIcon,
      ),
    );
  }
}

extension ButtonExtension on RoundedRectangleBorder {
  devitaButton() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
      side: BorderSide(
        color: CoreColor().appGreen,
      ),
    );
  }
}
