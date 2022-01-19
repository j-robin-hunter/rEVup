import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revup/classes/validators.dart';
import 'package:revup/extensions/string_casing_extension.dart';
import 'package:revup/models/profile.dart';
import 'package:revup/services/auth_service.dart';
import 'package:revup/services/firebase_firestore_service.dart';
import 'package:revup/widgets/error_dialog.dart';
import 'package:revup/widgets/padded_password_form_field.dart';
import 'package:revup/widgets/padded_text_form_field.dart';

class ProfileForm extends StatefulWidget {
  final User user;

  const ProfileForm({Key? key, required this.user}) : super(key: key);

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

  final String _accountType = 'Customer';

  bool changed = false;

  @override
  void initState() {
    super.initState();
    _name.addListener(() => _name.value = _name.value.copyWith(text: _name.text.toLowerCase().toTitleCase()));
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context);
    final FirebaseFirestoreService _firebaseFirestoreService = Provider.of<FirebaseFirestoreService>(context);

    return FutureBuilder(
      future: _firebaseFirestoreService.getProfile(widget.user.email!),
      builder: (context, snapshot) {
        if (snapshot.hasData || snapshot.hasError) {
          Profile _profile;
          if (snapshot.hasData) {
            _profile = snapshot.data as Profile;
          } else {
            _profile = Profile(email: widget.user.email!);
          }
          _profile.setType(_accountType);
          _name.text = widget.user.displayName ?? '';
          _email.text = _profile.email;
          _companyName.text = _profile.company ?? '';
          _streetAddressOne.text = _profile.addressOne ?? '';
          _streetAddressTwo.text = _profile.addressTwo ?? '';
          _city.text = _profile.city ?? '';
          _county.text = _profile.county ?? '';
          _postcode.text = _profile.postcode ?? '';
          _phone.text = _profile.phone ?? '';
          return Form(
            key: _formKey,
            onChanged: () => changed = true,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text('Account type: $_accountType'),
                  ),
                  PaddedTextFormField(
                    controller: _name,
                    validator: Validators.validateNotEmpty,
                    labelText: 'Your name',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  PaddedTextFormField(
                    onSaved: (value) => _profile.setEmail(value!),
                    // Cannot be null due to validator
                    controller: _email,
                    validator: Validators.validateEmail,
                    labelText: 'Email',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  PaddedTextFormField(
                    onSaved: (value) => _profile.setCompany(value!),
                    labelText: 'Company Name',
                    controller: _companyName,
                    padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 8.0),
                  ),
                  PaddedTextFormField(
                    onSaved: (value) => _profile.setAddressOne(value!),
                    labelText: 'Address',
                    hintText: 'Address',
                    controller: _streetAddressOne,
                    padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 8.0),
                  ),
                  PaddedTextFormField(
                    onSaved: (value) => _profile.setAddressTwo(value!),
                    controller: _streetAddressTwo,
                    padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 8.0),
                  ),
                  PaddedTextFormField(
                    onSaved: (value) => _profile.setCity(value!),
                    labelText: 'City',
                    hintText: 'City',
                    controller: _city,
                    padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 8.0),
                  ),
                  PaddedTextFormField(
                    onSaved: (value) => _profile.setCounty(value!),
                    labelText: 'County',
                    hintText: 'County',
                    controller: _county,
                    padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 8.0),
                  ),
                  PaddedTextFormField(
                    onSaved: (value) => _profile.setPostcode(value!),
                    labelText: 'Postcode',
                    hintText: 'Postcode',
                    controller: _postcode,
                    validator: Validators.validatePostcodeNotRequired,
                    padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 8.0),
                  ),
                  PaddedTextFormField(
                    onSaved: (value) => _profile.setPhone(value!),
                    labelText: 'Phone',
                    hintText: 'Phone',
                    controller: _phone,
                    validator: Validators.validatePhoneNotRequired,
                    padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 8.0),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
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
                                  return _passwordResetDialog(context, widget.user, _authService);
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
                            onPressed: () async {
                              if (changed) {
                                if (_formKey.currentState!.validate()) {
                                  if (widget.user.displayName != _name.text) {
                                    await _authService.updateUserDisplayName(widget.user, _name.text);
                                  }
                                }
                                if (widget.user.email != _email.text) {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return _emailResetDialog(context, widget.user, _authService);
                                    },
                                  ).then((password) {
                                    if (password != null) {
                                      String newEmail = _email.text;
                                      _formKey.currentState?.save();
                                      _authService.updateUserEmail(widget.user, newEmail, password).then((_) {
                                        _profile.setEmail(newEmail);
                                        _firebaseFirestoreService.setProfile(_profile).then((value) {
                                          _profile.setId(value);
                                          Navigator.pop(context);
                                        });
                                      }).catchError((error) {
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ErrorDialog(error: 'Unable to change account email. ${error.toString()}');
                                          },
                                        );
                                      });
                                    }
                                  });
                                } else {
                                  _formKey.currentState?.save();
                                  _profile.setId(await _firebaseFirestoreService.setProfile(_profile));
                                  Navigator.pop(context);
                                }
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('OK'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
          /*
        } else if (snapshot.hasError) {
          //ToDo
          return const Text('An error');

           */
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 10.0),
                Text('Loading user profile'),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _passwordResetDialog(BuildContext context, User user, AuthService authService) {
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
              _auth.resetPasswordRequest(user.email!);
              _auth.signOut();
              Navigator.pushNamed(context, '/');
            }),
      ],
    );
  }

  Widget _emailResetDialog(BuildContext context, User user, AuthService authService) {
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
}
