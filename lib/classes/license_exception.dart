//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

class LicenseException implements Exception {
  final String _cause;

  LicenseException(this._cause);

  @override
  String toString() => _cause;
}