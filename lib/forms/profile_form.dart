//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revup/classes/validators.dart';
import 'package:revup/extensions/string_casing_extension.dart';
import 'package:revup/models/profile.dart';
import 'package:revup/services/auth_service.dart';
import 'package:revup/services/profile_service.dart';
import 'package:revup/widgets/future_dialog.dart';
import 'package:revup/widgets/padded_password_form_field.dart';
import 'package:revup/widgets/padded_text_form_field.dart';

class ProfileForm extends StatefulWidget {
  final Profile profile;
  final Function callback;

  const ProfileForm({Key? key, required this.profile, required this.callback}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProfileFormState();
  }
}

class ProfileFormState extends State<ProfileForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _resetKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _companyName = TextEditingController();
  final _streetAddressOne = TextEditingController();
  final _streetAddressTwo = TextEditingController();
  final _city = TextEditingController();
  final _county = TextEditingController();
  final _postcode = TextEditingController();
  final _phone = TextEditingController();

  bool changed = false;

  @override
  void initState() {
    super.initState();
    _name.text = widget.profile.name;
    _email.text = widget.profile.email;
    _companyName.text = widget.profile.company;
    _streetAddressOne.text = widget.profile.addressOne;
    _streetAddressTwo.text = widget.profile.addressTwo;
    _city.text = widget.profile.city;
    _county.text = widget.profile.county;
    _postcode.text = widget.profile.postcode;
    _phone.text = widget.profile.phone;
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _companyName.dispose();
    _streetAddressOne.dispose();
    _streetAddressTwo.dispose();
    _city.dispose();
    _county.dispose();
    _postcode.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context);

    _name.addListener(() => _name.value = _name.value.copyWith(text: _name.text.toLowerCase().toTitleCase()));
    _companyName.addListener(() => _companyName.value = _companyName.value.copyWith(text: _companyName.text.toLowerCase().toTitleCase()));
    _streetAddressOne
        .addListener(() => _streetAddressOne.value = _streetAddressOne.value.copyWith(text: _streetAddressOne.text.toLowerCase().toTitleCase()));
    _streetAddressTwo
        .addListener(() => _streetAddressTwo.value = _streetAddressTwo.value.copyWith(text: _streetAddressTwo.text.toLowerCase().toTitleCase()));
    _city.addListener(() => _city.value = _city.value.copyWith(text: _city.text.toLowerCase().toTitleCase()));
    _county.addListener(() => _county.value = _county.value.copyWith(text: _county.text.toLowerCase().toTitleCase()));
    _postcode.addListener(() => _postcode.value = _postcode.value.copyWith(text: _postcode.text.toUpperCase()));
    _phone.addListener(() => _phone.value = _phone.value.copyWith(text: _phone.text.replaceAll(RegExp(r'[^+(\) \d]'), '')));

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        onChanged: () {
          setState(() => changed = true);
          widget.callback('changed');
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text('Account type: ${widget.profile.type}'),
            ),
            PaddedTextFormField(
              onSaved: (value) => widget.profile.setName(value!),
              controller: _name,
              validator: Validators.validateNotEmpty,
              labelText: 'Name',
              hintText: 'Your name',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            PaddedTextFormField(
              onSaved: (value) => widget.profile.setEmail(value!),
              // Cannot be null due to validator
              controller: _email,
              validator: Validators.validateEmail,
              labelText: 'Email',
              hintText: 'Your email address',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            PaddedTextFormField(
              onSaved: (value) => widget.profile.setCompany(value!),
              labelText: 'Company Name',
              controller: _companyName,
              padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 8.0),
            ),
            PaddedTextFormField(
              onSaved: (value) => widget.profile.setAddressOne(value!),
              labelText: 'Address',
              hintText: 'Address',
              controller: _streetAddressOne,
              padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 8.0),
            ),
            PaddedTextFormField(
              onSaved: (value) => widget.profile.setAddressTwo(value!),
              controller: _streetAddressTwo,
              padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 8.0),
            ),
            PaddedTextFormField(
              onSaved: (value) => widget.profile.setCity(value!),
              labelText: 'City',
              hintText: 'City',
              controller: _city,
              padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 8.0),
            ),
            PaddedTextFormField(
              onSaved: (value) => widget.profile.setCounty(value!),
              labelText: 'County',
              hintText: 'County',
              controller: _county,
              padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 8.0),
            ),
            PaddedTextFormField(
              onSaved: (value) => widget.profile.setPostcode(value!),
              labelText: 'Postcode',
              hintText: 'Your postcode',
              controller: _postcode,
              validator: Validators.validatePostcodeNotRequired,
              padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 8.0),
            ),
            PaddedTextFormField(
              onSaved: (value) => widget.profile.setPhone(value!),
              labelText: 'Phone',
              hintText: 'Your phone number',
              controller: _phone,
              validator: Validators.validatePhoneNotRequired,
              padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 8.0),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: 40.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return _passwordResetDialog(context);
                            },
                          );
                        },
                        child: const Text('Reset Password'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 40.0,
                      child: ElevatedButton(
                          child: const Text('OK'),
                          onPressed: changed == false
                              ? null
                              : () {
                                  if (_email.text != widget.profile.email) {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return _emailResetDialog(context);
                                        }).then((password) {
                                      if (password != null) {
                                        _authService.updateUserEmail(_email.text, password);
                                        _saveProfile(context);
                                      }
                                    }).catchError((error) {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const Dialog(); //ErrorDialog(error: 'Unable to change account email. ${error.toString()}');
                                          });
                                    });
                                  } else {
                                    _saveProfile(context);
                                  }
                                }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _passwordResetDialog(BuildContext context) {
    AuthService _auth = Provider.of<AuthService>(context);
    return AlertDialog(
      title: const Text(
        'Password Reset',
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
        height: 120.0,
        child: Center(
            child: Column(
          children: const <Widget>[
            Text('The password reset will send a password change email to your current registered email.'),
            SizedBox(height: 10.0),
            Text('You will be logged out to allowing you to login again with your new password.'),
          ],
        )),
      ),
      actions: <Widget>[
        TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            }),
        TextButton(
            child: const Text('Reset'),
            onPressed: () {
              _auth.resetPasswordRequest(widget.profile.email);
              _auth.signOut();
              Navigator.pushNamed(context, '/');
            }),
      ],
    );
  }

  Widget _emailResetDialog(BuildContext context) {
    TextEditingController _confirmEmail = TextEditingController();
    TextEditingController _confirmPassword = TextEditingController();
    return AlertDialog(
      title: const Text(
        'Email Reset',
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
        height: 225.0,
        child: Center(
          child: Form(
            key: _resetKey,
            child: Column(
              children: <Widget>[
                PaddedTextFormField(
                  controller: _confirmEmail,
                  validator: _emailMatch,
                  labelText: 'Confirm New Email',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                PaddedPasswordFormField(
                  controller: _confirmPassword,
                  labelText: 'Password',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Password must be at least 8 characters in length, contain at least: one uppercase letter, one lowercase letter, one number and one special character',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 10.0,
                    ),
                  ),
                ),
                const Text('Please confirm your new email and current password to authorise your email change request.'),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            }),
        TextButton(
          child: const Text('Submit'),
          onPressed: () async {
            if (_resetKey.currentState!.validate()) {
              Navigator.pop(context, _confirmPassword.text);
            }
          },
        ),
      ],
    );
  }

  String? _emailMatch(String? value) {
    if (value != _email.text) {
      return 'New email not matched';
    }
    return null;
  }

  void _saveProfile(BuildContext context) {
    final ProfileService _profileService = Provider.of<ProfileService>(context, listen:false);
    _formKey.currentState!.save();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return FutureDialog(
          future: Future.wait([
            _profileService.saveProfile(widget.profile),
            Future.delayed(const Duration(seconds: 1), () => 0), // to allow dialog to be seen
          ]),
          waitingString: 'Saving profile ...',
          hasDataActions: const <Widget>[],
          hasErrorActions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    ).then((_) {
      widget.callback('done');
      setState(() => changed = false);
    }); // leave settings if save is OK
  }
}
