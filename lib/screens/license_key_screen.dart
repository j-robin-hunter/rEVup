//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revup/services/license_service.dart';
import 'package:revup/widgets/padded_password_form_field.dart';
import 'package:revup/widgets/page_template.dart';

class LicenseKeyScreen extends StatelessWidget {
  const LicenseKeyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LicenseService _licenseService = Provider.of<LicenseService>(context);

    return Scaffold(
      body: SafeArea(
        child: PageTemplate(
          topImage: false,
          action: const SizedBox.shrink(),
          body: _licenseKeyScreenBody(context, _licenseService.license.id ?? ''),
        ),
      ),
    );
  }

  Widget _licenseKeyScreenBody(BuildContext context, String licenseId) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final _licenseId = TextEditingController();

    return Form(
      key: _formKey,
      child: Container(
        height: 400.0,
        constraints: const BoxConstraints(
          minWidth: 400,
          maxWidth: 800,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 250.0,
              child: PaddedPasswordFormField(
                hintText: 'License ID',
                controller: _licenseId,
                validator: (value) {
                  if (value != licenseId) {
                    return 'Incorrect ID entered - check case';
                  }
                  return null;
                },
                labelText: 'License ID',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
            ),
            const SizedBox(width: 12.0),
            SizedBox(
              height: 36.0,
              width: 110.0,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushNamed(context, '/initialLicensee');
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
