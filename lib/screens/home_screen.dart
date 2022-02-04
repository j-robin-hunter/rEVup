//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revup/models/license.dart';
import 'package:revup/models/profile.dart';
import 'package:revup/services/auth_service.dart';
import 'package:revup/services/license_service.dart';
import 'package:revup/services/profile_service.dart';
import 'package:revup/widgets/error_dialog.dart';
import 'package:revup/widgets/page_template.dart';
import 'package:revup/widgets/page_waiting.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  bool switched = false; // Not a state variable used to prevent multiple popups

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context);
    final ProfileService _profileService = Provider.of<ProfileService>(context);
    final LicenseService _licenseService = Provider.of<LicenseService>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: Future.wait([_authService.user, _licenseService.loadLicense()]),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _error(context, snapshot.error.toString());
            } else if (snapshot.hasData) {
              List futures = snapshot.data as List;
              User? user = futures[0][0];
              License license = futures[1];
              return FutureBuilder(
                future: license.cmsService == null
                    ? Future.wait([_profileService.loadProfile(user)])
                    : Future.wait([_profileService.loadProfile(user), license.cmsService!.loadCmsContent()]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List future = snapshot.data as List;
                    Profile profile = future[0] as Profile;
                    List<String> licensedToList = profile.licencedTo.split(RegExp(r",\s*"));
                    if (user != null && licensedToList.length > 1 && !switched) {
                      switched = true;
                      Future.delayed(Duration.zero, () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => _selectLicensee(context, license.licensee, licensedToList),
                        ).then((selectedLicensee) async {
                          license.setLicensee('');
                          await _licenseService.loadLicense(selectedLicensee);
                          setState(() => switched = true);
                        }).catchError((e) {
                          showDialog(barrierDismissible: false, context: context, builder: (context) => ErrorDialog(error: 'Cannot change partner: $e'));
                        });
                      });
                    }
                    return PageTemplate(
                      action: user == null || user.emailVerified == false ? const SizedBox.shrink() : _welcome(context, profile),
                      body: _homeBodyScreen(context, user, license, profile, _authService),
                      topImage: false,
                      logoPosition: user == null ? Alignment.center : Alignment.centerRight,
                    );
                  } else if (snapshot.hasError) {
                    return _error(context, 'Unable to load application profile.');
                  } else {
                    return const PageWaiting(message: 'Please wait ... loading profile');
                  }
                },
              );
            } else {
              return const PageWaiting(message: 'Please wait ... checking application status');
            }
          },
        ),
      ),
    );
  }

  Widget _homeBodyScreen(BuildContext context, User? user, License license, Profile profile, AuthService authService) {
    return SingleChildScrollView(
      child: Container(
        height: 400.0,
        constraints: const BoxConstraints(
          minWidth: 400,
          maxWidth: 800,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(3.0),
          ),
          image: DecorationImage(
            image: AssetImage('lib/assets/images/earth.png'),
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
                  license.emailService == null
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 36.0,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/enquiry');
                              },
                              child: const Text('Make an Enquiry'),
                            ),
                          ),
                        ),
                  license.cmsService == null
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 36.0,
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.pushNamed(context, '/quote');
                              },
                              child: const Text('Request a Quote'),
                            ),
                          ),
                        ),
                  license.supportService == null
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 36.0,
                            child: ElevatedButton(
                              onPressed: () async {},
                              child: const Text('Get Support'),
                            ),
                          ),
                        ),
                  SizedBox(
                    width: double.infinity,
                    height: 36.0,
                    child: user == null || !user.emailVerified
                        ? ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: const Text('Sign in'),
                          )
                        : TextButton(
                            onPressed: () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return _logoutDialog(context, authService);
                                },
                              );
                            },
                            child: const Text('Sign out'),
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

  Widget _welcome(BuildContext context, Profile profile) {
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: () {
        Navigator.pushNamed(context, '/setup');
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (profile.photoUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(profile.photoUrl),
              ),
            ),
          profile.name.isNotEmpty
              ? Text(
                  'Hi ${profile.name}',
                  style: const TextStyle(color: Colors.white),
                )
              : Text(
                  'Hi ${profile.email}',
                  style: const TextStyle(color: Colors.white),
                ),
        ],
      ),
    );
  }

  Widget _error(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('The following unexpected error has occurred:'),
          const SizedBox(height: 5.0),
          Text(
            error,
            style: TextStyle(
              color: Theme.of(context).errorColor,
            ),
          ),
          const SizedBox(height: 15.0),
          const Text('Please contact technical@romatech.co.uk'),
        ],
      ),
    );
  }

  Widget _logoutDialog(BuildContext context, AuthService _auth) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
      ),
      contentPadding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
      content: const SizedBox(
        width: 400.0,
        height: 60.0,
        child: Center(child: Text('Do you really want to logout?')),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('No'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('Yes'),
          onPressed: () async {
            await _auth.signOut();
            Navigator.pushNamed(context, '/');
          },
        ),
      ],
    );
  }

  Widget _selectLicensee(BuildContext context, String licensee, List<String> licensedToList) {
    return AlertDialog(
      title: const Text(
        'Select Partner',
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
      ),
      contentPadding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
      content: SizedBox(
        width: 400.0,
        height: 175.0,
        child: Column(
          children: <Widget>[
            DropdownButtonFormField(
              items: licensedToList
                  .map((String item) => DropdownMenuItem<String>(
                      child: Text(
                        item.trim(),
                        style: const TextStyle(color: Colors.black54),
                      ),
                      value: item))
                  .toList(),
              onChanged: (value) => licensee = value.toString(),
              value: licensee,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: Text(
                'You are registered with more than one partner. Please select which partner you would like to work with today from the selection above.\n\nYou can change your partner later if you sign out and and sign back in again.',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
            child: const Text('Submit'),
            onPressed: () async {
              Navigator.pop(context, licensee);
            }),
      ],
    );
  }
}
