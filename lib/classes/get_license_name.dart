//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'dart:js' as js;
import 'dart:convert';

class GetLicenseName {
  static String get name {
    try {
      var jsBrand = js.JsObject.fromBrowserObject(js.context['license']);
      return utf8.decode(base64.decode(jsBrand['id']));
    } catch (e) {
      throw Exception('Unable to get license id');
    }
  }
}
