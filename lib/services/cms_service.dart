//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:revup/classes/cms_service_exception.dart';
import 'package:revup/models/cms_content.dart';

import 'concrete/contentful_cms_service.dart';

abstract class CmsService {
  String licensee = '';
  final Map<String, CmsContent> cmsContent = {};

  CmsService();

  factory CmsService.fromMap(Map<String, dynamic> map) {
    if (map['serviceName'] != null) {
      switch (map['serviceName'].toLowerCase()) {
        case 'contentful':
          return ContentfulCmsService.fromMap(map);
      }
    }
    throw CmsServiceException('Encountered invalid CMS service definition data');
  }

  Map<String, dynamic> get map;

  Future<void> loadCmsContent();

  CmsContent? getCmsContent(String key) => cmsContent[key];
}
