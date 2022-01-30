//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:revup/models/license.dart';
import 'package:revup/models/profile.dart';

class ProfileService extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final Profile _profile = Profile();

  CollectionReference<Map<String, dynamic>> _getProfiles() {
    return _firebaseFirestore.collection('profiles');
  }

  Profile get profile => _profile;

  Future<Profile> loadProfile(License license, User? user) async {
    await _getProfiles().where('licencedTo', isEqualTo: license.licensee).where('email', isEqualTo: user?.email ?? '').get().then((event) {
      if (event.docs.isNotEmpty) {
        var profileData = event.docs.first.data();
        _profile.setFromMap(profileData);
        _profile.id = event.docs.first.id;
        if (_profile.name.isEmpty) _profile.name = profileData['name'] ?? '';
        if (_profile.photoUrl.isEmpty) _profile.photoUrl = profileData['photoUrl'] ?? '';
      } else {
        _profile.setLicensedTo(license.licensee);
        _profile.setEmail(user?.email ?? '');
        _profile.setName(user?.displayName ?? '');
        _profile.setPhotoUrl(user?.photoURL ?? '');
      }
    }).catchError((e) {
      throw Exception('Unable to load profile data. Unexpected missing data.');
    });
    return _profile;
  }

  Future<String?> saveProfile(Profile profile) async {
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
}
