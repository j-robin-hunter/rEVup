//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:revup/services/product_service.dart';

class ZohoInventoryProductService extends ProductService {
  final String clientId;
  final String clientSecret;
  final String refreshToken;
  final String redirectUri;
  final String tokenUri;

  ZohoInventoryProductService({
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

  static ProductService fromMap(Map<String, dynamic> map) {
    return ZohoInventoryProductService(
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
}
