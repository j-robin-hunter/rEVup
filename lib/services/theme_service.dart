//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  String? _branding;

  ThemeService([this._branding]);

  ThemeData get themeData {
    if (_branding == null) {
      return ThemeData.dark();
    }
    return ThemeData.dark().copyWith(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
        ),
      ),
    );
  }

  void setBranding(String? branding) {
    _branding = branding;
    notifyListeners();
  }
}

/*
ThemeData(
primarySwatch: branding.primarySwatch,
secondaryHeaderColor: branding.secondaryHeaderColor,
unselectedWidgetColor: branding.unselectedWidgetColor,
highlightColor: branding.highlightColor,
bottomAppBarColor: branding.bottomAppBarColor,
appBarTheme: AppBarTheme(
backgroundColor: branding.appBarThemeBackgroundColor,
foregroundColor: branding.appBarThemeForegroundColor,
),
elevatedButtonTheme: ElevatedButtonThemeData(
style: ButtonStyle(
foregroundColor: MaterialStateProperty.all<Color>(branding.elevatedButtonThemeForegroundColor),
),
),
floatingActionButtonTheme: FloatingActionButtonThemeData(
backgroundColor: branding.floatingActionButtonThemeBackgroundColor,
foregroundColor: branding.floatingActionButtonThemeForegroundColor,
),
inputDecorationTheme: InputDecorationTheme(
isDense: true,
labelStyle: TextStyle(
color: branding.inputDecorationThemeLabelStyleColor,
),
hintStyle: const TextStyle(
color: Colors.black26,
),
floatingLabelBehavior: FloatingLabelBehavior.auto,
floatingLabelStyle: TextStyle(
color: branding.inputDecorationThemeFloatingLabelStyleColor,
),
enabledBorder: OutlineInputBorder(
borderSide: BorderSide(
color: branding.inputDecorationThemeEnabledBorderColor,
width: 1,
),
borderRadius: BorderRadius.circular(5),
),
focusedBorder: OutlineInputBorder(
borderSide: BorderSide(
color: branding.inputDecorationThemeFocusedBorderColor,
width: 1,
),
borderRadius: BorderRadius.circular(5),
),
focusedErrorBorder: OutlineInputBorder(
borderSide: BorderSide(
color: branding.inputDecorationThemeFocusedErrorBorderColor,
width: 1,
),
),
errorBorder: OutlineInputBorder(
borderSide: BorderSide(
color: branding.inputDecorationThemeErrorBorderColor,
width: 1,
),
),
filled: true,
fillColor: branding.inputDecorationThemeFillColor,
),
errorColor: branding.errorColor,
),
*/
