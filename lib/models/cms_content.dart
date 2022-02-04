//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************
import 'package:flutter/material.dart';

class CmsContent {
  final Widget? _textContent;
  final Image? _mediaContent;

  CmsContent(this._textContent, this._mediaContent);

  Widget? get textContent => _textContent;
  Image? get mediaContent => _mediaContent;
}
