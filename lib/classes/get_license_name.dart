//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:revup/classes/license_exception.dart';

class GetLicenseName {
  static Future<String> get licensee async {
    try {
      return utf8.decode(base64.decode(await rootBundle.loadString('lib/assets/license.txt')));
    } catch (e) {
      throw LicenseException('Unable to get license id');
    }
  }
}

