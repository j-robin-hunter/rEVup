//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:revup/classes/get_license_name.dart';
import 'package:revup/models/license.dart';

class LicenseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final License _license = License();
  Image _logo = Image.asset('lib/assets/images/logo-rev-230x132.png');

  CollectionReference<Map<String, dynamic>> _getLicenses() {
    return _firebaseFirestore.collection('licenses');
  }

  License get license => _license;

  Image get logo => _logo;

  Future<License> loadLicense([String licensee = '']) async {
    if (_license.licensee.isNotEmpty) {
      if (licensee.isEmpty || licensee == _license.licensee) {
        return _license;
      }
    }
    if (licensee.isEmpty) licensee = GetLicenseName.name;

    await _getLicenses().where('licensee', isEqualTo: licensee).get().then((event) {
      if (event.docs.isNotEmpty) {
        var licenseData = event.docs.first.data();
        _license.setFromMap(licenseData);
      } else {
        throw Exception('Unable to load license data. Unexpected missing data.');
      }
    }).catchError((e) {
      throw Exception('Unable to load license data. Unexpected missing data.');
    });
    _logo = Image.network(_license.logoUrl);
    return _license;
  }

  Future<void> saveLicense(License license) async {
    _license.updated = DateTime.now();
    await _getLicenses().doc(_license.id).set(_license.map);
  }
}
