//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

class SupportServiceException implements Exception {
  final String _cause;

  SupportServiceException(this._cause);

  @override
  String toString() => _cause;
}