//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:revup/classes/get_license_name.dart';
import 'package:revup/classes/no_license_exception.dart';
import 'package:revup/models/license.dart';

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
        throw Exception('Missing licensing data.');
      }
    }).catchError((e) {
      throw NoLicenseException();
    });
    return _license;
  }

  Future<void> saveLicense() async {
    _license.created ??= DateTime.now();
    try {
      await _getLicenses().doc(_license.id).set(_license.map);
    } catch(e) {
      // Todo
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
}
