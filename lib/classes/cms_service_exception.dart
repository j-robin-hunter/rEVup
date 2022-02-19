//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

class CmsServiceException implements Exception {
  final String _cause;

  CmsServiceException(this._cause);

  @override
  String toString() => _cause;
}