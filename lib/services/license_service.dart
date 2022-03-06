//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:revup/classes/get_license_name.dart';
import 'package:revup/classes/license_exception.dart';
import 'package:revup/models/license.dart';
import 'package:revup/services/product_service.dart';
import 'package:revup/services/support_service.dart';
import 'cms_service.dart';
import 'email_service.dart';
import 'firebase_storage_service.dart';

class LicenseService extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final License _license = License();

  License get license => _license;

  CollectionReference<Map<String, dynamic>> _getLicenses() {
    return _firebaseFirestore.collection('licenses');
  }

  Future<License> loadLicense([String licensee = '']) async {
    if (_license.created != null) {
      if (licensee.isEmpty || licensee == _license.licensee) {
        return _license;
      }
    }
    if (licensee.isEmpty) licensee = await GetLicenseName.licensee;

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
    Map<String, dynamic> images = await FirebaseStorageService.downloadUint8List('license', _license.id!);
    images.forEach((key, value) {
      Image image = Image.memory(value);
      _license.branding.setImage(key, image);
    });
    return _license;
  }

  Future<License> reLoadLicense() async {
    _license.created = null;
    _license.branding.brandImages.forEach((key, value) {
      _license.branding.setImage(key, Image.asset('lib/assets/images/transparent.png'));
    });
    await loadLicense();
    setTheme(getTheme());
    return _license;
  }

  String? get licenseId => _license.id;

  String get licensee => _license.licensee;

  DateTime? get created => _license.created;

  String get profileId => _license.profileId;

  void setProfileId(String value) => _license.setProfileId(value);

  Future<void> saveLicense() async {
    try {
      _license.branding.brandImages.forEach((key, value) async {
        var image = _license.branding.brandImages[key]['image'].image;
        if (image is MemoryImage) {
          Reference ref = await FirebaseStorageService.uploadUint8List('license', _license.id!, key, image.bytes);
          _license.branding.brandImages[key]['ref'] = ref.fullPath;
        }
      });
      await _getLicenses().doc(_license.id).set(_license.map);
    } catch (e) {
      throw LicenseException('Unable to save license data.');
    }
  }

  ThemeData get themeData {
    return _license.branding.themeData;
  }

  String getTheme() {
    return _license.branding.theme;
  }

  void setTheme(String theme) {
    _license.branding.setTheme(theme);
    notifyListeners();
  }

  Color? getThemeColor(key) {
    return _license.branding.brandColors[key];
  }

  void setThemeColor(String key, Color color) {
    _license.branding.setThemeColor(key, color);
    notifyListeners();
  }

  void deleteThemeColor(String key) {
    _license.branding.deleteThemeColor(key);
    notifyListeners();
  }

  List<String> getColors() {
    return _license.branding.colors;
  }

  Map<String, dynamic> getImage(String name) {
    return _license.branding.getImage(name);
  }

  void setImage(String key, Image image) {
    _license.branding.setImage(key, image);
    notifyListeners();
  }

  void setService(String serviceType, String serviceName, Map map) {
    Map<String, String> service = map.map((key, value) => MapEntry(key, value['controller'].text));
    service['serviceName'] = serviceName;
    switch (serviceType) {
      case 'CMS':
        _license.setCmsService(CmsService.fromMap(service));
        break;
      case 'Email':
        _license.setEmailService(EmailService.fromMap(service));
        break;
      case 'Product':
        _license.setProductService(ProductService.fromMap(service));
        break;
      case 'Support':
        _license.setSupportService(SupportService.fromMap(service));
        break;
    }
  }

  Map getServiceDefinition(String serviceType) {
    switch (serviceType.toLowerCase()) {
      case 'email':
        return _license.emailService?.map ?? {};
      case 'cms':
        return _license.cmsService?.map ?? {};
      case 'product':
        return _license.productService?.map ?? {};
      case 'support':
        return _license.supportService?.map ?? {};
    }
    return {};
  }

  EmailService? get emailService => _license.emailService;

  CmsService? get cmsService => _license.cmsService;

  SupportService? get supportService => _license.supportService;
}
