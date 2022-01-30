//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'dart:js' as js;
import 'package:revup/services/email_service.dart';

class License {
  late String id;
  String logoUrl = '';
  String licensee = '';
  List<String> administrators = [];
  EmailService? emailService;
  DateTime? created;
  DateTime? updated;

  License() {
    try {
      var jsBrand = js.JsObject.fromBrowserObject(js.context['license']);
      id = jsBrand['id'];
    } catch (e) {
      throw Exception('Unable to get license id');
    }
    created = DateTime.now();
    updated = DateTime.now();
  }
  Map<String, dynamic> get map {
    Map<String, dynamic> map = {
      'licensee': licensee,
      'logoUrl': logoUrl,
      'administrators': administrators,
    };
    map.addAll(emailService!.map);
    return map;
  }

  void setFromMap(Map<String, dynamic> map) {
    try {
      setLicensee(map['licensee']);
      setLogoUrl(map['logoUrl']);
      setAdministrators(List.from(map['administrators']));
      if (map['emailService'] != null) setEmailService(EmailService.fromMap(map['emailService']));
    } catch(e) {
      throw Exception(e.toString());
    }
  }

  setLicensee(String value) => licensee = value;

  setEmailService(EmailService value) => emailService = value;

  setLogoUrl(String value) => logoUrl = value;

  setAdministrators(List<String> value) => administrators = value;

  setId(String value) => id = value;

  setUpdated(DateTime value) => updated = value;
}
