//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'dart:convert';
import 'package:revup/classes/support_service_exception.dart';
import 'package:revup/services/support_service.dart';
import 'package:http/http.dart' as http;

class ZohoDeskSupportService extends SupportService {
  final String clientId;
  final String clientSecret;
  final String refreshToken;
  final String redirectUri;
  final String tokenUri;

  ZohoDeskSupportService({
    required this.clientId,
    required this.clientSecret,
    required this.refreshToken,
    required this.redirectUri,
    required this.tokenUri,
    required serviceName,
    required serviceApiUrl,
  }) : super(
    serviceName: serviceName,
    serviceApiUrl: serviceApiUrl,
  );

  static SupportService fromMap(Map<String, dynamic> map) {
    return ZohoDeskSupportService(
      serviceName: map['serviceName'],
      serviceApiUrl: map['serviceApiUrl'],
      clientId: map['clientId'],
      clientSecret: map['clientSecret'],
      refreshToken: map['refreshToken'],
      redirectUri: map['redirectUri'],
      tokenUri: map['tokenUri'],
    );
  }

  @override
  Map<String, dynamic> get map => {
    'serviceName': serviceName,
    'serviceApiUrl': serviceApiUrl,
    'clientId': clientId,
    'clientSecret': clientSecret,
    'refreshToken': refreshToken,
    'redirectUri': redirectUri,
    'tokenUri': tokenUri,
  };

  @override
  Future<void> createSupportTicket() async {
    String accessToken = await _getAccessToken();
    http.Response response = await http.get(
      Uri.parse('$serviceApiUrl/tickets'),
      headers: {
        'Authorization': 'Zoho-oauthtoken $accessToken',
      },
    );
  }

  Future<String> _getAccessToken() async {
    try {
      http.Response response = await http.post(
        Uri.parse(tokenUri),
        body: {
          'refresh_token': refreshToken,
          'client_id': clientId,
          'client_secret': clientSecret,
          'grant_type': 'refresh_token',
          'redirect_uri': redirectUri,
        },
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['access_token'];
      }
      throw SupportServiceException('Unexpected response received from Support service. Code: ${response.statusCode}');
    } catch (e) {
      throw SupportServiceException('Unable to read data from Support service.');
    }
  }
}
