import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:revup/forms/profile_form.dart';
import 'package:revup/widgets/page_template.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? _user = ModalRoute.of(context)!.settings.arguments as User?;

    return Scaffold(
      body: SafeArea(
        child: PageTemplate(
          body: _profileScreenBody(_user),
        ),
      ),
    );
  }

  Widget _profileScreenBody(User? _user) {
    return _user == null
        ? const Text('You are not authorised to access this page')
        : Padding(
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
                        'User Profile',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Container(
                      height: 400.0,
                      constraints: const BoxConstraints(
                        minWidth: 400,
                        maxWidth: 800,
                      ),
                      alignment: Alignment.centerLeft,
                      // align your child's position.
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ProfileForm(user: _user),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
