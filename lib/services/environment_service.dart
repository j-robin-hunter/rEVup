//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:revup/models/environment.dart';

class EnvironmentService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Environment? _environment;

  CollectionReference<Map<String, dynamic>> _getEnvironment() {
    return _firebaseFirestore.collection('environment');
  }

  Environment get environment => _environment!;

  Future<Environment> loadEnvironment() async {
    if (_environment != null) return _environment!;
    await _getEnvironment().get().then((env) {
      if (env.docs.isNotEmpty) {
        var envData = env.docs.first.data();
        _environment = Environment.fromMap(envData);
      }
    }).catchError((e) {
      throw Exception('Unable to load application environment.');
    });
    return _environment!;
  }
}
