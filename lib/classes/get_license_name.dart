//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class GetLicenseName {
  static Future<String> get licensee async {
    try {
      return utf8.decode(base64.decode(await rootBundle.loadString('lib/assets/license.txt')));
    } catch (e) {
      throw Exception('Unable to get license id');
    }
  }
}

