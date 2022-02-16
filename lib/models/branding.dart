//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';
import 'package:revup/classes/create_material_color.dart';

class Branding {
  static const airSuperiorityBlue = 0xff579aba;
  static const greenSheen = 0xff84c1c1;
  static const midGrey = 0xff777777;
  static const veryDarkGrey = 0xff2a2a2a;

  String logoUrl = '';
  Image logo = Image.asset('lib/assets/images/transparent.png');
  String backgroundImageUrl = '';
  ThemeData _themeData = ThemeData.light();
  String _theme = 'light';
  final Map<String, Color?> _brandColors = {};
  final List<String> colors = [
    'Text',
    'Primary',
    'Secondary Header',
    'Unselected Widget',
    'Highlight',
    'Error',
    'Bottom App Bar',
    'App Bar Foreground',
    'App Bar Background',
    'Elevated Button Foreground',
    'Elevated Button Background',
    'Floating Button Foreground',
    'Floating Button Background',
    'Input Fill',
    'Input Label',
    'Input Hint',
    'Floating Label',
    'Input Enabled Border',
    'Input Error Border',
    'Input Focused Border',
    'Input Focused Error Border',
  ];

  ImageProvider get getBackgroundImageUrl {
    if (backgroundImageUrl.isNotEmpty) {
      return NetworkImage(backgroundImageUrl);
    } else {
      return const AssetImage('lib/assets/images/earth.png');
    }
  }

  ThemeData get themeData => _themeData;

  String get theme => _theme;

  Map<String, Color?> get brandColors => _brandColors;

  Map<String, dynamic> get map {
    Map<String, dynamic> _map = {
      'theme': theme,
    };
    if (_brandColors.isNotEmpty) {
      _map['colors'] = <String, int>{};
      _brandColors.forEach((key, color) {
        _map['colors'][key] = color?.value;
      });
    }
    return _map;
  }

  void setTheme(String theme) {
    _theme = theme;
    Brightness brightness = Brightness.light;
    if (theme != 'light') brightness = Brightness.dark;
    _themeData = ThemeData(
      brightness: brightness,
      primarySwatch: _brandColors['Primary'] != null ? createMaterialColor(_brandColors['Primary']!) : null,
      secondaryHeaderColor: _brandColors['Secondary Header'],
      unselectedWidgetColor: _brandColors['Unselected Widget'],
      highlightColor: _brandColors['Highlight'],
      errorColor: _brandColors['Error'],
      bottomAppBarColor: _brandColors['Bottom App Bar'],
      primaryColor: Colors.red,
      textTheme: _brandColors.containsKey('Text')
          ? TextTheme(
              bodyText1: TextStyle(
                color: _brandColors['Text'],
              ),
            )
          : null,
      appBarTheme: AppBarTheme(
        foregroundColor: _brandColors['App Bar Foreground'],
        backgroundColor: _brandColors['App Bar Background'],
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          foregroundColor:
              _brandColors.containsKey('Elevated Button Foreground') ? MaterialStateProperty.all(_brandColors['Elevated Button Foreground']) : null,
          backgroundColor:
              _brandColors.containsKey('Elevated Button Background') ? MaterialStateProperty.all(_brandColors['Elevated Button Background']) : null,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: _brandColors['Floating Button Foreground'],
        backgroundColor: _brandColors['Floating Button Background'],
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: _brandColors.containsKey('Input Fill') ? true : false,
        fillColor: _brandColors['Input Fill'],
        labelStyle: TextStyle(
          color: _brandColors['Input Label'],
        ),
        hintStyle: TextStyle(
          color: _brandColors['Input Hint'],
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: TextStyle(
          color: _brandColors['Floating Label'],
        ),
        enabledBorder: _brandColors.containsKey('Input Enabled Border')
            ? OutlineInputBorder(
                borderSide: BorderSide(
                  color: _brandColors['Input Enabled Border']!,
                ),
                borderRadius: BorderRadius.circular(5.0),
              )
            : null,
        errorBorder: _brandColors.containsKey('Input Error Border')
            ? OutlineInputBorder(
                borderSide: BorderSide(
                  color: _brandColors['Input Error Border']!,
                ),
                borderRadius: BorderRadius.circular(5.0),
              )
            : null,
        focusedBorder: _brandColors.containsKey('Input Focused Border')
            ? OutlineInputBorder(
                borderSide: BorderSide(
                  color: _brandColors['Input Focused Border']!,
                ),
                borderRadius: BorderRadius.circular(5.0),
              )
            : null,
        focusedErrorBorder: _brandColors.containsKey('Input Focused Error Border')
            ? OutlineInputBorder(
                borderSide: BorderSide(
                  color: _brandColors['Input Focused Error Border']!,
                ),
                borderRadius: BorderRadius.circular(5.0),
              )
            : null,
      ),
    );
  }

  void setThemeColor(String key, Color color) {
    _brandColors[key] = color;
    setTheme(_themeData.brightness == Brightness.light ? 'light' : 'dark');
  }

  void deleteThemeColor(String key) {
    _brandColors.remove(key);
    //_setThemeColors(_brandColors);
    setTheme(_themeData.brightness == Brightness.light ? 'light' : 'dark');
  }

  void setLogoUrl(String value) {
    logoUrl = value;
    if (value.isNotEmpty) logo = Image.network(value);
  }
}
