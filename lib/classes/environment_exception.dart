//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

class EnvironmentException implements Exception {
  final String _cause;

  EnvironmentException(this._cause);

  @override
  String toString() => _cause;
}