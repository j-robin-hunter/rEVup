//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revup/classes/authentication_exception.dart';
import 'package:revup/forms/admin_form.dart';
import 'package:revup/models/license.dart';
import 'package:revup/models/profile.dart';
import 'package:revup/services/auth_service.dart';
import 'package:revup/services/license_service.dart';
import 'package:revup/services/profile_service.dart';
import 'package:revup/widgets/page_error.dart';
import 'package:revup/widgets/page_template.dart';
import 'package:revup/widgets/page_waiting.dart';

class InitialLicenseScreen extends StatelessWidget {
  const InitialLicenseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context);
    final ProfileService _profileService = Provider.of<ProfileService>(context);
    final LicenseService _licenseService = Provider.of<LicenseService>(context);
    final License _license = _licenseService.license;

    return Theme(
      data: _license.branding.themeData,
      child: Scaffold(
        body: SafeArea(
          child: FutureBuilder(
            future: _authService.signInAnonymously(),
            builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
              if (snapshot.hasError) {
                return snapshot.error is AuthenticationException
                    ? const PageError(error: 'Database connection refused.')
                    : PageError(error: snapshot.error.toString());
              } else if (snapshot.hasData) {
                return PageTemplate(
                  topImage: false,
                  action: const SizedBox.shrink(),
                  body: _initialLicenseScreenBody(context, _profileService.profile, _license),
                );
              } else {
                return const PageWaiting(message: 'Please wait ... connecting to database');
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _initialLicenseScreenBody(BuildContext context, Profile profile, License license) {
    List<Widget> tabs = [const Tab(text: 'Admin')];
    List<Widget> tabBarViews = [AdminForm(license: license, callback: callback)];

    return license.profile.isNotEmpty
        ? const Text('You are not authorised to access this page')
        : Container(
            constraints: const BoxConstraints(
              minWidth: 400,
              maxWidth: 800,
            ),
            child: DefaultTabController(
              length: tabs.length,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Align(
                      child: TabBar(
                        labelColor: Theme.of(context).textTheme.bodyText1?.color,
                        tabs: tabs,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: tabBarViews,
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  void callback(String value) {
    print(value);
  }
}
