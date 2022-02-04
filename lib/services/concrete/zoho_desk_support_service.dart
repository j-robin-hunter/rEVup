//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import '../support_service.dart';

class ZohoDeskSupportService extends SupportService {
  final String serviceName;

  ZohoDeskSupportService({
    required this.serviceName,
  }) : super();

  static SupportService fromMap(Map<String, dynamic> map) {
    return ZohoDeskSupportService(
      serviceName: map['serviceName'],
    );
  }

  @override
  Map<String, dynamic> get map => {
    'serviceName': serviceName,
  };
}
