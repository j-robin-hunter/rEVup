//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

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
    switch (map['serviceName'].toLowerCase()) {
      case 'mailjet':
      default:
        return MailjetEmailService.fromMap(map);
    }
  }

  Map<String, dynamic> get map;
  Future<bool> sendEnquiryEmail(Map<String, dynamic> enquiry);
}
