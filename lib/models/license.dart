//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:revup/classes/cms_service_exception.dart';
import 'package:revup/classes/email_service_exception.dart';
import 'package:revup/classes/support_service_exception.dart';
import 'package:revup/services/cms_service.dart';
import 'package:revup/services/email_service.dart';
import 'package:revup/services/support_service.dart';

import '../services/product_service.dart';
import 'branding.dart';

class License {
  String? _id;
  String _licensee = '';
  String _profileId = '';
  final Branding _branding = Branding();
  EmailService? _emailService;
  CmsService? _cmsService;
  SupportService? _supportService;
  ProductService? _productService;
  DateTime? created;
  DateTime? _updated;

  Map<String, dynamic> get map {
    Map<String, dynamic> map = {
      'licensee': _licensee,
      'profileId': _profileId,
      'created': created,
      'updated': _updated,
    };
    map['branding'] = _branding.map;
    if (_cmsService != null) map['cmsService'] = _cmsService?.map;
    if (_emailService != null) map['emailService'] = _emailService?.map;
    return map;
  }

  void setFromMap(Map<String, dynamic> map) {
    try {
      _licensee = map['licensee'];
      _profileId = map['profileId'] ?? '';
      created = map['created'] != null ? (map['created'] as Timestamp).toDate() : DateTime.now();
      if (map['updated'] != null) _updated = (map['updated'] as Timestamp).toDate();
      if (map['branding'] != null) _branding.fromMap(map['branding']);
      try {
        setEmailService(EmailService.fromMap(map['emailService'] ?? {}));
      } on EmailServiceException {
        _emailService = null;
      } catch (ex) {
        throw Exception('Email service: ${ex.toString()}');
      }
      try {
        setCmsService(CmsService.fromMap(map['cmsService'] ?? {}));
        //_cmsService!.licensee = _licensee;
      } on CmsServiceException {
        _cmsService = null;
      } catch (ex) {
        throw Exception('CMS service: ${ex.toString()}');
      }
      try {
        setSupportService(SupportService.fromMap(map['supportService'] ?? {}));
      } on SupportServiceException {
        _supportService = null;
      } catch (ex) {
        throw Exception('Support service: ${ex.toString()}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  String? get id => _id;

  String get licensee => _licensee;

  String get profileId => _profileId;

  Branding get branding => _branding;

  EmailService? get emailService => _emailService;

  CmsService? get cmsService => _cmsService;

  SupportService? get supportService => _supportService;

  ProductService? get productService => _productService;

  DateTime? get updated => _updated;

  setLicensee(String value) {
    _licensee = value;
    _updated = DateTime.now();
  }

  setProfileId(String value) {
    _profileId = value;
    _updated = DateTime.now();
  }

  setEmailService(EmailService value) {
    _emailService = value;
    _updated = DateTime.now();
  }

  setCmsService(CmsService value) {
    _cmsService = value;
    _updated = DateTime.now();
  }

  setSupportService(SupportService value) {
    _supportService = value;
    _updated = DateTime.now();
  }

  setProductService(ProductService value) {
    _productService = value;
    _updated = DateTime.now();
  }

  setId(String value) {
    _id = value;
    _updated = DateTime.now();
  }

/*
  setCreated(DateTime value) {
    _created = value;
    _updated = value;
  }
  */
}
