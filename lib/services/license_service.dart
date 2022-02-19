//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:revup/classes/get_license_name.dart';
import 'package:revup/classes/license_exception.dart';
import 'package:revup/models/license.dart';

import 'cms_service.dart';

class LicenseService extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final License _license = License();

  CollectionReference<Map<String, dynamic>> _getLicenses() {
    return _firebaseFirestore.collection('licenses');
  }

  License get license => _license;

  Future<License> loadLicense([String licensee = '']) async {
    if (_license.licensee.isNotEmpty) {
      if (licensee.isEmpty || licensee == _license.licensee) {
        return _license;
      }
    }
    if (licensee.isEmpty)  licensee = await GetLicenseName.licensee;

    await _getLicenses().where('licensee', isEqualTo: licensee).get().then((event) {
      if (event.docs.isNotEmpty) {
        var licenseData = event.docs.first.data();
        _license.setFromMap(licenseData);
        _license.setId(event.docs.first.id);
      } else {
        throw LicenseException('Missing licensing data.');
      }
    }).catchError((e) {
      throw LicenseException('Unable to load license data. ${e.toString()}');
    });
    return _license;
  }

  Future<void> saveLicense() async {
    _license.created ??= DateTime.now();
    try {
      await _getLicenses().doc(_license.id).set(_license.map);
    } catch(e) {
      throw LicenseException('Unable to save license data.');
    }
  }

  ThemeData getThemeData() {
    return _license.branding.themeData;
  }

  void setTheme(String theme) {
    _license.branding.setTheme(theme);
    notifyListeners();
  }

  void setThemeColor(String key, Color color) {
    _license.branding.setThemeColor(key, color);
    notifyListeners();
  }

  void deleteThemeColor(String key) {
    _license.branding.deleteThemeColor(key);
    notifyListeners();
  }

  void setServices(String serviceType, String serviceName, Map map) {
    Map<String, String> service = map.map((key, value) => MapEntry(key, value['controller'].text));
    service['serviceName'] = serviceName;
    switch(serviceType) {
      case 'CMS':
        _license.setCmsService(CmsService.fromMap(service));
        break;
      case 'Email':
        break;
      case 'Product':
        break;
      case 'Support':
        break;
    }
  }
}
