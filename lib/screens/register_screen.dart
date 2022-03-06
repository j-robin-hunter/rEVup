//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revup/widgets/page_template.dart';
import 'package:revup/forms/register_form.dart';

import '../models/license.dart';
import '../services/license_service.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageTemplate(
          body: _registerScreenBody(context),
          topImage: false,
        ),
      ),
    );
  }

  Widget _registerScreenBody(BuildContext context) {
    final License _license = Provider.of<LicenseService>(context).license;
    return Card(
      elevation: 1,
      child: Container(
        height: 400.0,
        constraints: const BoxConstraints(
          minWidth: 400,
          maxWidth: 800,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(3.0),
          ),
          image: DecorationImage(
            image: _license.branding.getImage('background')['image'].image,
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.centerLeft,
        // align your child's position.
        child: const Padding(
          padding: EdgeInsets.only(left: 50.0),
          child: SizedBox(
            width: 294.0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: RegisterForm(),
            ),
          ),
        ),
      ),
    );
  }
}
