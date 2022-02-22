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
import '../classes/authentication_exception.dart';
import '../forms/admin_form.dart';
import '../services/auth_service.dart';
import '../widgets/page_error.dart';
import '../widgets/page_waiting.dart';

class LicenseKeyScreen extends StatefulWidget {
  const LicenseKeyScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LicenseKeyScreenState();
  }
}

class LicenseKeyScreenState extends State<LicenseKeyScreen> {
  final _licenseId = TextEditingController();

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
              ? _initialLicenseScreenBody(context)
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

  Widget _initialLicenseScreenBody(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context, listen: false);
    List<Widget> tabs = [const Tab(text: 'Admin')];
    List<Widget> tabBarViews = [const AdminForm()];

    return FutureBuilder(
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
                        labelColor: Theme
                            .of(context)
                            .textTheme
                            .bodyText1
                            ?.color,
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
}
