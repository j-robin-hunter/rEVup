//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:revup/classes/support_service_exception.dart';
import 'concrete/zoho_desk_support_service.dart';

abstract class SupportService {
  SupportService();

  factory SupportService.fromMap(Map<String, dynamic> map) {
    if (map['serviceName'] != null) {
      switch (map['serviceName'].toLowerCase()) {
        case 'zoho desk':
          return ZohoDeskSupportService.fromMap(map);
      }
    }
    throw SupportServiceException('Encountered invalid Support service definition data');
  }

  Future<void> createSupportTicket();
}
