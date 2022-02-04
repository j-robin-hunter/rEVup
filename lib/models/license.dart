//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:revup/classes/no_cms_service_exception.dart';
import 'package:revup/classes/no_email_service_exception.dart';
import 'package:revup/classes/no_support_service_exception.dart';
import 'package:revup/services/cms_service.dart';
import 'package:revup/services/email_service.dart';
import 'package:revup/services/support_service.dart';

class License {
  late String id;
  String logoUrl = '';
  String licensee = '';
  List<String> administrators = [];
  EmailService? emailService;
  CmsService? cmsService;
  SupportService? supportService;

  DateTime? created;
  DateTime? updated;

  License() {
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
      setLogoUrl(map['logoUrl'] ?? '');
      setAdministrators(List.from(map['administrators'] ?? []));
      try {
        setEmailService(EmailService.fromMap(map['emailService'] ?? {}));
      } on NoEmailServiceException {
        emailService = null;
      } catch (ex) {
        throw Exception('Email service: ${ex.toString()}');
      }
      try {
        setCmsService(CmsService.fromMap(map['cmsService'] ?? {}));
        cmsService!.licensee = licensee;
      } on NoCmsServiceException {
        cmsService = null;
      } catch (ex) {
        throw Exception('CMS service: ${ex.toString()}');
      }
      try {
        setSupportService(SupportService.fromMap(map['supportService'] ?? {}));
      } on NoSupportServiceException {
        supportService = null;
      } catch (ex) {
        throw Exception('Support service: ${ex.toString()}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  setLicensee(String value) => licensee = value;

  setEmailService(EmailService value) => emailService = value;

  setCmsService(CmsService value) => cmsService = value;

  setSupportService(SupportService value) => supportService = value;

  setLogoUrl(String value) => logoUrl = value;

  setAdministrators(List<String> value) => administrators = value;

  setId(String value) => id = value;

  setUpdated(DateTime value) => updated = value;
}
