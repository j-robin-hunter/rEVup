//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'dart:convert';
import '../../services/email_service.dart';
import 'package:http/http.dart' as http;

class MailjetEmailService extends EmailService {
  final String apiKey;
  final String secretKey;
  final int enquiryTemplate;
  final int enquiryConfirmTemplate;


  MailjetEmailService({
    required this.apiKey,
    required this.secretKey,
    required this.enquiryTemplate,
    required this.enquiryConfirmTemplate,
    required emailFromName,
    required emailServiceApiUrl,
    required enquiryEmailSubject,
    required enquiryToEmail,
  }) : super(
          emailServiceApiUrl: emailServiceApiUrl,
          emailFromName: emailFromName,
          enquiryToEmail: enquiryToEmail,
          enquiryEmailSubject: enquiryEmailSubject,
        );

  static EmailService fromMap(Map<String, dynamic> map) {
    return MailjetEmailService(
      emailServiceApiUrl: map['emailServiceApiUrl'],
      emailFromName: map['emailFromName'],
      enquiryToEmail: map['enquiryToEmail'],
      enquiryEmailSubject: map['enquiryEmailSubject'],
      apiKey: map['mailjetApiKey'],
      secretKey: map['mailjetSecretKey'],
      enquiryTemplate: map['enquiryTemplate'],
      enquiryConfirmTemplate: map['enquiryConfirmTemplate'],
    );
  }

  @override
  Map<String, dynamic> get map => {
    'emailServiceApiUrl': emailServiceApiUrl,
    'enquiryEmailSubject': enquiryEmailSubject,
    'enquiryToEmail': enquiryToEmail,
    'apiKey': apiKey,
    'secretKey': secretKey,
    'enquiryTemplate': enquiryTemplate,
    'enquiryConfirmTemplate': enquiryConfirmTemplate,
  };

  @override
  Future<bool> sendEnquiryEmail(Map<String, dynamic> enquiry) async {
    final url = Uri.parse(emailServiceApiUrl);
    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ' + base64Encode(utf8.encode('$apiKey:$secretKey')),
      },
      body: json.encode({
        'Messages': [
          {
            'From': {
              'Email': enquiry['email'],
              'Name': enquiry['name'],
            },
            'To': [
              {
                'Email': enquiryToEmail,
                'Name': emailFromName,
              },
            ],
            'TemplateID': enquiryTemplate,
            'TemplateLanguage': true,
            'Subject': enquiryEmailSubject,
            'Variables': {
              'subject': enquiry['subject'],
              'message': enquiry['message'],
              'userName': enquiry['name'],
              'userEmail': enquiry['email'],
              'userPhone': enquiry['phone'],
              'brandName' : emailFromName,
            },
          },
        ],
      }),
    );
    if (response.statusCode != 200) {
      // todo
      print(response.body.toString());
      throw Exception();
    }

    // Send confirmation
    response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ' + base64Encode(utf8.encode('$apiKey:$secretKey')),
      },
      body: json.encode({
        'Messages': [
          {
            'From': {
              'Email': enquiry['email'],
              'Name': enquiry['name'],
            },
            'To': [
              {
                'Email': enquiry['email'],
                'Name': enquiry['name'],
              },
            ],
            'TemplateID': enquiryConfirmTemplate,
            'TemplateLanguage': true,
            'Subject': enquiryEmailSubject,
            'Variables': {
              'subject': enquiry['subject'],
              'message': enquiry['message'],
              'userName': enquiry['name'],
              'userEmail': enquiry['email'],
              'userPhone': enquiry['phone'],
              'brandName' : emailFromName,
            },
          },
        ],
      }),
    );
    if (response.statusCode != 200) {
      // todo
      print(response.body.toString());
      throw Exception();
    }

    return true;
  }
}