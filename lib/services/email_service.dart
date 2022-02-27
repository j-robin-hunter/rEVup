//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:revup/classes/email_service_exception.dart';
import 'package:revup/services/concrete/mailjet_email_service.dart';

abstract class EmailService {
  final String serviceApiUrl;

  EmailService({
    required this.serviceApiUrl,
  });

  factory EmailService.fromMap(Map<String, dynamic> map) {
    if (map['serviceName'] != null) {
      switch (map['serviceName'].toLowerCase()) {
        case 'mailjet':
          return MailjetEmailService.fromMap(map);
      }
    }
    throw EmailServiceException('Encountered invalid Email service definition data');
  }

  Map<String, dynamic> get map;

  Future<bool> sendEnquiryEmail(Map<String, dynamic> enquiry);
}
