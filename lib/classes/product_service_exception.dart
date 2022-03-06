//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

class ProductServiceException implements Exception {
  final String _cause;

  ProductServiceException(this._cause);

  @override
  String toString() => _cause;
}