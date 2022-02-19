//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:revup/classes/environment_exception.dart';

class Environment {
  final List<String> _products = [];
  final Map<String, dynamic> _services = {};

  void fromMap(Map<String, dynamic> map) {
    try {
      if (_products.isEmpty) _products.addAll([...map['products']]);
      if (_services.isEmpty) _services.addAll(map['services']);
    } catch (e) {
      throw EnvironmentException('Invalid system level environment data.');
    }
  }

  Map<String, dynamic> get services => _services;

  List<String> get products => _products;
}
