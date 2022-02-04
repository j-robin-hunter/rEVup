//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revup/classes/validators.dart';
import 'package:revup/services/auth_service.dart';
import 'package:revup/widgets/future_dialog.dart';
import 'package:revup/widgets/padded_password_form_field.dart';
import 'package:revup/widgets/padded_text_form_field.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final AuthService _authService = Provider.of<AuthService>(context);

    final _email = TextEditingController();
    final _password = TextEditingController();

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: Text(
              'Create account',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
          PaddedTextFormField(
            controller: _email,
            validator: Validators.validateEmail,
            labelText: 'Email',
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          PaddedPasswordFormField(
            controller: _password,
            labelText: 'Password',
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          SizedBox(
            width: double.infinity,
            height: 36.0,
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return FutureDialog(
                        height: 140.0,
                        future: _authService.createUserWithEmailAndPassword(_email.text, _password.text),
                        waitingString: 'Creating user ...',
                        hasDataTitle: 'User Created',
                        hasDataString:
                            'A new account has been created. It will need to be verified before it can be used. A verification email has been sent to ${_email.text}.',
                        hasDataActions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, '/'),
                            child: const Text('OK'),
                          ),
                        ],
                        hasErrorTitle: 'Unable to Create User',
                        hasErrorActions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Create account'),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              'Password must be at least 8 characters in length, contain at least: one uppercase letter, one lowercase letter, one number and one special character',
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontSize: 14.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
