//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'dart:convert';

import 'package:revup/classes/no_support_service_exception.dart';
import 'package:revup/services/support_service.dart';
import 'package:http/http.dart' as http;

class ZohoDeskSupportService extends SupportService {
  final String serviceName;
  final String serviceApiUrl;
  final Map oauth;

  ZohoDeskSupportService({
    required this.serviceName,
    required this.serviceApiUrl,
    required this.oauth,
  }) : super();

  static SupportService fromMap(Map<String, dynamic> map) {
    return ZohoDeskSupportService(
      serviceName: map['serviceName'],
      serviceApiUrl: map['serviceApiUrl'],
      oauth: map['oauth2'],
    );
  }

  @override
  Future<void> createSupportTicket() async {
    String accessToken = await _getAccessToken();
    http.Response response = await http.get(
      Uri.parse('$serviceApiUrl/tickets'),
      headers: {
        'Authorization': 'Zoho-oauthtoken $accessToken',
      },
    );
    print(response.body);
  }

  Future<String> _getAccessToken() async {
    try {
      http.Response response = await http.post(
        Uri.parse(oauth['tokenUri']),
        body: {
          'refresh_token': oauth['refresh'],
          'client_id': oauth['id'],
          'client_secret': oauth['secret'],
          'grant_type': 'refresh_token',
          'redirect_uri': oauth['redirectUri'],
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['access_token'];
      }
      throw NoSupportServiceException();
    } catch (e) {
      throw NoSupportServiceException();
    }
  }
}
