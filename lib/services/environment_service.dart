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

  final Environment _environment = Environment();

  Environment get environment => _environment;

  CollectionReference<Map<String, dynamic>> _getEnvironment() {
    return _firebaseFirestore.collection('environment');
  }

  Future<Environment> loadEnvironment() async {
    await _getEnvironment()
        .get()
        .then((event) => _environment.fromMap(event.docs.first.data()))
        .catchError((e) => throw Exception('Unable to load application environment'));
    return _environment;
  }
}
