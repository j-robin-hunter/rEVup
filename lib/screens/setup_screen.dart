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
import 'package:revup/forms/email_templates_form.dart';
import 'package:revup/forms/profile_form.dart';
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
  Map parent = {};

  @override
  Widget build(BuildContext context) {
    final ProfileService _profileService = Provider.of<ProfileService>(context);
    final LicenseService _licenseService = Provider.of<LicenseService>(context);

    bool isAdmin = _licenseService.profileId == _profileService.profile.id;
    return Scaffold(
      body: SafeArea(
        child: PageTemplate(
          body: _setupScreenBody(context, isAdmin, parent),
        ),
      ),
    );
  }

  Widget _setupScreenBody(BuildContext context, bool isAdmin, Map parent) {
    final Profile profile = Provider.of<ProfileService>(context).profile;

    List<Widget> tabs = [const Tab(text: 'Profile')];
    List<Widget> tabBarViews = [ProfileForm(callback: callback)];

    if (profile.type == 'Installer' || profile.type == 'Administrator') {
      tabs.add(const Tab(text: 'Account',));
      tabBarViews.add(const AccountForm());
    }
    if (isAdmin) {
      tabs.add(const Tab(text: 'Admin'));
      tabBarViews.add(AdminForm(callback: callback));
      tabs.add(const Tab(text: 'Email Templates'));
      tabBarViews.add(EmailTemplateForm(callback: callback));
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
                        labelColor: Theme.of(context).textTheme.bodyText1!.color,
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

  void callback(Map value) {
    print(value);
    setState(() => parent = value);
  }
}
