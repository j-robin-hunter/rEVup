//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revup/forms/enquiry_form.dart';
import 'package:revup/models/profile.dart';
import 'package:revup/services/profile_service.dart';
import 'package:revup/widgets/page_template.dart';

class EnquiryScreen extends StatelessWidget {
  const EnquiryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileService _profileService = Provider.of<ProfileService>(context);

    return Scaffold(
      body: SafeArea(
        child: PageTemplate(
          body: _enquiryScreenBody(_profileService.profile),
        ),
      ),
    );
  }

  Widget _enquiryScreenBody(Profile profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: SingleChildScrollView(
        child: Container(
          height: 460.0,
          constraints: const BoxConstraints(
            minWidth: 400,
            maxWidth: 800,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Your Enquiry',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Container(
                height: 420.0,
                constraints: const BoxConstraints(
                  minWidth: 400,
                  maxWidth: 800,
                ),
                alignment: Alignment.centerLeft,
                // align your child's position.
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: EnquiryForm(profile: profile),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
