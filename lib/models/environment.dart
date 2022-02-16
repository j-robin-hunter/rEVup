//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:revup/classes/no_environment_exception.dart';

class Environment {
  final Map<String, dynamic> _serviceDefinitions = {};

  void setFromMap(Map<String, dynamic> map) {
    if (_serviceDefinitions.isEmpty) {
      try {
        for (var service in map['services'].keys.toList()) {
          for (var element in map['services'][service]['services']) {
            for (var key in element.keys) {
              element[key].addAll(map['services']['email']);
              element[key].remove('services');
              if (!_serviceDefinitions.containsKey(service)) _serviceDefinitions[service] = [];
              _serviceDefinitions[service].add({key: element});
            }
          }
        }
      } catch (e) {
        throw NoEnvironmentException();
      }
    }
  }

  Map<String,dynamic> get services => _serviceDefinitions;
}
