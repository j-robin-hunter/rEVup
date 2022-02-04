//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revup/forms/quote_form.dart';
import 'package:revup/services/license_service.dart';
import 'package:revup/widgets/page_template.dart';

class QuoteScreen extends StatelessWidget {
  const QuoteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageTemplate(
          body: _quoteScreenBody(Provider.of<LicenseService>(context)),
        ),
      ),
    );
  }

  Widget _quoteScreenBody(LicenseService licenseService) {
    return licenseService.license.licensee.isEmpty ? const Text('You are not authorised to access this page') : const QuoteForm();
  }
}
