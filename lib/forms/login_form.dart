//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:revup/classes/validators.dart';
import 'package:revup/services/auth_service.dart';
import 'package:revup/widgets/padded_password_form_field.dart';
import 'package:revup/widgets/padded_text_form_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _resetKey = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _rememberMe = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthService _authService = Provider.of<AuthService>(context);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Sign in',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                    fontSize: 18.0,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'or',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1!.color,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text(
                        'create account',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: SizedBox(
              height: 36.0,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await _authService.signInWithGoogle(_rememberMe);
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const <Widget>[
                    FaIcon(FontAwesomeIcons.google, size: 16.0),
                    Text('Sign in with Google'),
                    SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: SizedBox(
              height: 36.0,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await _authService.signInWithGoogle(_rememberMe);
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const <Widget>[
                    FaIcon(FontAwesomeIcons.facebookF, size: 16.0),
                    Text('Sign in with Facebook'),
                    SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),
          Text(
            'or',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
          ),
          PaddedTextFormField(
            controller: _email,
            validator: Validators.validateEmail,
            labelText: 'Email',
            floatingLabelBehavior: FloatingLabelBehavior.never,
            focusNode: _focusNode,
          ),
          PaddedPasswordFormField(
            controller: _password,
            labelText: 'Password',
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              children: <Widget>[
                Checkbox(
                  value: _rememberMe,
                  onChanged: (bool? value) {
                    setState(() {
                      _rememberMe = value!;
                    });
                  },
                ),
                Text(
                  'Remember me',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
                Expanded(child: Container()),
                SizedBox(
                  height: 36.0,
                  width: 110.0,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          User? user = await _authService.signInWithEmailAndPassword(_email.text, _password.text, _rememberMe);
                          if (user!.emailVerified == false) {
                            await _authService.verifyEmailAddress(user);
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return _notVerifiedDialog();
                              },
                            );
                          } else {
                            Navigator.pushNamed(context, '/');
                          }
                        } catch (e) {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return _loginFailureDialog();
                            },
                          );
                        }
                      }
                    },
                    child: const Text('Sign in'),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return _passwordResetDialog(context);
                      },
                    );
                  },
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginFailureDialog() {
    return AlertDialog(
      title: const Text(
        'Login Error',
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
      ),
      contentPadding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
      content: const SizedBox(
        width: 400.0,
        height: 60.0,
        child: Center(
          child: Text('The account may not exist or you may have provided an incorrect email or password'),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Retry'),
          onPressed: () {
            _password.clear();
            _focusNode.requestFocus();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _notVerifiedDialog() {
    return AlertDialog(
      title: const Text(
        'Account Not Verified',
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
      ),
      contentPadding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
      content: const SizedBox(
        width: 400.0,
        height: 60.0,
        child: Center(
          child: Text(
              'Your email has not yet been verified. An email has been sent to your email address. Please open this to verify your account and then try to login again.'),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
        ),
      ],
    );
  }

  Widget _passwordResetDialog(BuildContext context) {
    AuthService _auth = Provider.of<AuthService>(context);
    TextEditingController _reset = TextEditingController();
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
        height: 115.0,
        child: Center(
          child: Form(
            key: _resetKey,
            child: Column(
              children: <Widget>[
                PaddedTextFormField(
                  controller: _reset,
                  validator: Validators.validateEmail,
                  labelText: 'Email',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  icon: const Icon(Icons.email),
                ),
                const Text('The password reset will send a password change email to the above email if your account is known.'),
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
          },
        ),
        TextButton(
          child: const Text('Reset'),
          onPressed: () async {
            if (_resetKey.currentState!.validate()) {
              await _auth.resetPasswordRequest(_reset.text);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
