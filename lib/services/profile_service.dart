//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:revup/models/profile.dart';

class ProfileService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final Profile _profile = Profile();

  CollectionReference<Map<String, dynamic>> _getProfiles() {
    return _firebaseFirestore.collection('profiles');
  }

  Profile get profile => _profile;

  Future<Profile> loadProfile(User? user) async {
    if (user != null) {
      await _getProfiles().where('email', isEqualTo: user.email ?? '').get().then((event) {
        if (event.docs.isNotEmpty) {
          var profileData = event.docs.first.data();
          _profile.setFromMap(profileData);
          _profile.id = event.docs.first.id;
          if (_profile.name.isEmpty) _profile.name = profileData['name'] ?? '';
          if (_profile.photoUrl.isEmpty) _profile.photoUrl = profileData['photoUrl'] ?? '';
        } else {
          _profile.setEmail(user.email ?? '');
          _profile.setName(user.displayName ?? '');
          _profile.setPhotoUrl(user.photoURL ?? '');
        }
      }).catchError((e) {
        throw Exception('Unable to load profile data. Unexpected missing data.');
      });
    }
    return _profile;
  }

  Future<String?> saveProfile(Profile profile) async {
    DocumentReference<Map<String, dynamic>>? documentReference;
    if (profile.id.isNotEmpty) {
      profile.updated = DateTime.now();
      _getProfiles().doc(profile.id).set(profile.map);
    } else {
      if (profile.email.isNotEmpty) {
        documentReference = await _getProfiles().add(profile.map);
        profile.setId(documentReference.id);
      }
    }
    return profile.id;
  }
}
