//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revup/forms/email_templates_form.dart';
import 'package:revup/services/license_service.dart';
import 'package:revup/widgets/padded_password_form_field.dart';
import 'package:revup/widgets/page_template.dart';
import '../classes/authentication_exception.dart';
import '../forms/admin_form.dart';
import '../forms/profile_form.dart';
import '../models/profile.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../widgets/page_error.dart';
import '../widgets/page_waiting.dart';

enum AdminStep { admin, profile, templates, completed }

class LicenseScreen extends StatefulWidget {
  const LicenseScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LicenseScreenState();
  }
}

class LicenseScreenState extends State<LicenseScreen> {
  final _licenseId = TextEditingController();
  AdminStep adminStep = AdminStep.admin;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _licenseId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LicenseService _licenseService = Provider.of<LicenseService>(context);

    return Scaffold(
      body: SafeArea(
        child: PageTemplate(
          topImage: false,
          action: const SizedBox.shrink(),
          body: _licenseService.licenseId == _licenseId.text
              ? _licenseScreenBody(context)
              : _licenseKeyScreenBody(context, _licenseService.licenseId ?? ''),
        ),
      ),
    );
  }

  Widget _licenseKeyScreenBody(BuildContext context, String licenseId) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Form(
      key: _formKey,
      child: Container(
        height: 460.0,
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
                  if (value != licenseId || value!.isEmpty) {
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
                    setState(() {});
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

  Widget _licenseScreenBody(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context, listen: false);
    final LicenseService _licenseService = Provider.of<LicenseService>(context, listen: false);
    final ProfileService _profileService = Provider.of<ProfileService>(context, listen: false);

    List<Widget> tabs = [const Tab(text: 'Admin')];
    List<Widget> tabBarViews = [AdminForm(callback: callback)];
    if (adminStep == AdminStep.profile) {
      tabs = [const Tab(text: 'Profile')];
      tabBarViews = [ProfileForm(callback: callback)];
    } else if (adminStep == AdminStep.templates) {
      tabs = [const Tab(text: 'Email Templates')];
      tabBarViews = [EmailTemplateForm(callback: callback)];
      Profile profile = _profileService.profile;
      _licenseService.setProfileId(profile.id);
      _licenseService.saveLicense();
    } else if (adminStep == AdminStep.completed) {
      _licenseService.saveLicense();
      _authService.deleteAnonymousUer(_authService.currentUser);
    }

    return adminStep == AdminStep.completed
        ? _licenseCompleted(context)
        : FutureBuilder(
            future: _authService.signInAnonymously(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return Container(
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
              } else if (snapshot.hasError) {
                return snapshot.error is AuthenticationException
                    ? const PageError(error: 'Database connection refused.')
                    : PageError(error: snapshot.error.toString());
              } else {
                return const PageWaiting(message: 'Please wait ... connecting to database');
              }
            },
          );
  }

  Widget _licenseCompleted(BuildContext context) {
    final LicenseService _licenseService = Provider.of<LicenseService>(context, listen: false);

    return Card(
      elevation: 1.0,
      child: Container(
        height: 400.0,
        constraints: const BoxConstraints(
          minWidth: 400,
          maxWidth: 800,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
          image: DecorationImage(
            image: _licenseService.getImage('background')['image'].image,
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.centerLeft,
        // align your child's position.
        child: Padding(
          padding: const EdgeInsets.only(left: 50.0),
          child: SizedBox(
            width: 294.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      'License Setup Completed',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1!.color,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 36.0,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pushNamed(context, '/');
                      },
                      child: const Text('OK'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void callback(AdminStep value) {
    if (value == AdminStep.admin) setState(() => adminStep = AdminStep.profile);
    if (value == AdminStep.profile) setState(() => adminStep = AdminStep.templates);
    if (value == AdminStep.templates) setState(() => adminStep = AdminStep.completed);
  }
}
