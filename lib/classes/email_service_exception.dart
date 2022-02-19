//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

class EmailServiceException implements Exception {
  final String _cause;

  EmailServiceException(this._cause);

  @override
  String toString() => _cause;
}