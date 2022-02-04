//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'dart:convert';

import 'package:contentful_rich_text/contentful_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:revup/models/cms_content.dart';
import '../cms_service.dart';
import 'package:http/http.dart';

class ContentfulCmsService extends CmsService {
  final String serviceName;
  final String serviceApiUrl;
  final String spaceId;
  final String accessToken;
  final String contentType;

  ContentfulCmsService({
    required this.serviceName,
    required this.serviceApiUrl,
    required this.spaceId,
    required this.accessToken,
    required this.contentType,
  });

  static CmsService fromMap(Map<String, dynamic> map) {
    return ContentfulCmsService(
      serviceName: map['serviceName'],
      serviceApiUrl: map['serviceApiUrl'],
      spaceId: map['spaceId'],
      accessToken: map['accessToken'],
      contentType: map['contentType'],
    );
  }

  @override
  Map<String, dynamic> get map => {
        'serviceName': serviceName,
        'serviceApiUrl': serviceApiUrl,
        'spaceId': spaceId,
        'accessToken': accessToken,
        'contentType': contentType,
      };

  @override
  Future<void> loadCmsContent() async {
    if (cmsContent.isEmpty) {
      String uri = '$serviceApiUrl/spaces/$spaceId/environments/master/entries?access_token=$accessToken&content_type=$contentType';
      await _getData(uri, 'fields.licensee=default');
      await _getData(uri, 'fields.licensee=$licensee');
    }
    return;
  }

  Future<void> _getData(String url, String? filter) async {
    if (filter != null) url = '$url&$filter';
    Response response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      try {
        var jsonResponse = jsonDecode(response.body);
        Map assetUrls = {};
        List assets = jsonResponse['includes'] != null ? jsonResponse['includes']['Asset'] : [];
        for (var asset in assets) {
          assetUrls[asset['sys']['id']] = asset['fields']['file']['url'];
        }
        List items = jsonResponse['items'];
        for (var item in items) {
          cmsContent[item['fields']['key']] = CmsContent(
            item['fields']['textContent'] != null ? ContentfulRichText(item['fields']['textContent']).documentToWidgetTree : null,
            item['fields']['mediaContent'] != null ? Image.network('https:${assetUrls[item['fields']['mediaContent']['sys']['id']]}') : null,
          );
        }
      } catch (ex) {
        throw Exception(ex);
      }
    }
    return;
  }
}
