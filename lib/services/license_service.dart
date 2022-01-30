//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  Future<License> loadLicense() async {
    if (_license.licensee.isNotEmpty) return _license;
    await _getLicenses().doc(_license.id).get().then((snapshot) => _license.setFromMap(snapshot.data()!)).catchError((e) {
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

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:revup/models/branding.dart';
import 'package:revup/models/install.dart';
import 'package:revup/models/profile.dart';

import 'branding_service.dart';

class FirebaseFirestoreService extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

 Profile _profile = Profile(licencedTo: '', email: '');

  CollectionReference<Map<String, dynamic>> _getBrandings() {
    return _firebaseFirestore.collection('brandings');
  }

  CollectionReference<Map<String, dynamic>> _getProfiles() {
    return _firebaseFirestore.collection('profiles');
  }

  Future<void> getBranding(BrandingService brandingService) async {
    Branding branding = brandingService.branding;
    if (!branding.isPopulated) {
      await _getBrandings().doc(branding.id).get().then((snapshot) => branding.setLicense(snapshot.data()));
    }
    return;
  }

  Future<String?> setProfile(Profile profile) async {
    DocumentReference<Map<String, dynamic>>? documentReference;
    if (profile.id != null) {
      profile.updated = DateTime.now();
      _getProfiles().doc(profile.id).set(profile.map);
    } else {
      if (profile.email.isNotEmpty) {
        documentReference = await _getProfiles().add(profile.map);
      }
    }
    return documentReference != null ? documentReference.id : profile.id;
  }

  Future<Profile> getProfile(Branding branding, User? user) async {
    if (_profile.email != '') return _profile;
    await _getProfiles().where('licencedTo', isEqualTo: branding.name).where('email', isEqualTo: _profile.email).get().then((event) {
      if (event.docs.isNotEmpty) {
        var profileData = event.docs.first.data();
        _profile = Profile.fromJson(profileData);
        _profile.id = event.docs.first.id;
        if (_profile.name.isEmpty) _profile.name = profileData['name'] ?? '';
        if (_profile.photoUrl.isEmpty) _profile.photoUrl = profileData['photoUrl'] ?? '';
      } else {
        _profile = Profile(
            licencedTo: branding.name,
            email: user?.email ?? '',
            name: user?.displayName ?? '',
            photoUrl: user?.photoURL ?? '',
            created: DateTime.now(),
            updated: DateTime.now()
        );
      }
    }).catchError((e) {
      // todo
      throw Exception('Unable to load profile data. Unexpected missing data,');
    });
    return _profile;
  }

  Stream<List<Install>> get installs {
    return _firebaseFirestore
        .collection('installs')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Install(who: doc.data()['who'])).toList());
  }
}

 */
