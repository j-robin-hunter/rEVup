//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';
import 'package:revup/classes/create_material_color.dart';

class Branding {
  ThemeData _themeData = ThemeData.light();
  String _theme = 'light';
  final Map<String, Color?> _brandColors = {};
  final List<String> colors = [
    'Canvas',
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
  final Map<String, Map<String, dynamic>> _brandImages = {
    'logo': {
      'name': 'Company\nLogo',
      'image': Image.asset('lib/assets/images/transparent.png'),
    },
    'background': {
      'name': 'Background\nImage',
      'image': Image.asset('lib/assets/images/transparent.png'),
    },
  };

  Map<String, dynamic> getImage(String name) {
    if (_brandImages.containsKey(name)) {
      return _brandImages[name]!;
    }
    return {
      'name': 'Undefined\nImage',
      'image': Image.asset('lib/assets/images/transparent.png'),
    };
  }

  ThemeData get themeData => _themeData;

  String get theme => _theme;

  Map<String, Color?> get brandColors => _brandColors;

  Map<String, dynamic> get brandImages => _brandImages;

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
    _map['images'] = {};
    _brandImages.forEach((key, value) {
      if (value['ref'] != null) {
        _map['images'][key] = value['ref'];
      }
    });
    return _map;
  }

  void fromMap(Map map) {
    if (map['images'] != null) {
      map['images'].forEach((key, value) {});
    }

    if (map['colors'] != null) {
      map['colors'].forEach((key, value) {
        if (colors.contains(key)) {
          _brandColors[key] = Color(value);
        }
      });
    }

    setTheme(map['theme'] ?? 'light');
  }

  void setTheme(String theme) {
    _theme = theme;
    Brightness brightness = Brightness.light;
    if (theme != 'light') brightness = Brightness.dark;
    _themeData = ThemeData(
      canvasColor: _brandColors['Canvas'],
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

  void setImage(String key, Image image) {
    _brandImages[key]!['image'] = image;
  }

  void deleteImage(String key) {}
}
