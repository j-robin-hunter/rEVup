//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revup/forms/account_form.dart';
import 'package:revup/forms/admin_form.dart';
import 'package:revup/forms/profile_form.dart';
import 'package:revup/models/license.dart';
import 'package:revup/models/profile.dart';
import 'package:revup/services/license_service.dart';
import 'package:revup/services/profile_service.dart';
import 'package:revup/widgets/page_template.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SetupScreenState();
  }
}

class SetupScreenState extends State<SetupScreen> {
  String parent = 'not changed';

  @override
  Widget build(BuildContext context) {
    final ProfileService _profileService = Provider.of<ProfileService>(context);
    final LicenseService _licenseService = Provider.of<LicenseService>(context);

    bool isAdmin = _licenseService.license.licensee == _profileService.profile.licencedTo &&
        _licenseService.license.administrators.contains(_profileService.profile.email);
    return Scaffold(
      body: SafeArea(
        child: PageTemplate(
          body: _setupScreenBody(_profileService.profile, _licenseService.license, isAdmin, parent),
        ),
      ),
    );
  }

  Widget _setupScreenBody(Profile profile, License license, bool isAdmin, String parent) {
    List<Widget> tabs = [const Tab(text: 'Profile')];
    List<Widget> tabBarViews = [ProfileForm(profile: profile, callback: callback)];

    if (profile.type == 'Installer' || profile.type == 'Administrator') {
      tabs.add(const Tab(text: 'Account'));
      tabBarViews.add(const AccountForm());
    }
    if (isAdmin) {
      tabs.add(const Tab(text: 'Admin'));
      tabBarViews.add(AdminForm(license: license, callback: callback));
    }

    return profile.email.isEmpty
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
    setState(() => parent = value);
  }
}
