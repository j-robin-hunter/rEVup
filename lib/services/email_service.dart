//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:revup/classes/no_email_service_exception.dart';
import 'package:revup/services/concrete/mailjet_email_service.dart';

abstract class EmailService {
  final String emailServiceApiUrl;
  final String emailFromName;
  final String enquiryEmailSubject;
  final String enquiryToEmail;

  EmailService({
    required this.emailServiceApiUrl,
    required this.emailFromName,
    required this.enquiryEmailSubject,
    required this.enquiryToEmail,
  });

  factory EmailService.fromMap(Map<String, dynamic> map) {
    if (map['serviceName'] != null) {
      switch (map['serviceName'].toLowerCase()) {
        case 'mailjet':
          return MailjetEmailService.fromMap(map);
      }
    }
    throw NoEmailServiceException();
  }

  Map<String, dynamic> get map;

  Future<bool> sendEnquiryEmail(Map<String, dynamic> enquiry);
}
