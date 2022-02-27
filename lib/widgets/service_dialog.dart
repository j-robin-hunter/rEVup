//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';
import 'package:revup/classes/validators.dart';
import 'package:revup/widgets/padded_password_form_field.dart';
import 'package:revup/widgets/padded_text_form_field.dart';

class ServiceDialog extends StatelessWidget {
  final Map content;
  final String namedService;

  const ServiceDialog({Key? key, required this.namedService, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    List<Widget> fields = [];
    for (var field in content.values) {
      Function(String?)? validator;
      if (field['validation'] != null) {
        switch (field['validation'].toString().toLowerCase()) {
          case 'notempty':
            validator = Validators.validateNotEmpty;
            break;
          case 'email':
            validator = Validators.validateEmail;
            break;
          case 'phone':
            validator = Validators.validatePhone;
            break;
          case 'phonenotrequired':
            validator = Validators.validatePhoneNotRequired;
            break;
          case 'positivenumber':
            validator = Validators.validatePositiveNumber;
            break;
          case 'positivenumbernotrequired':
            validator = Validators.validatePositiveNumberNotRequired;
            break;
          case 'url':
            validator = Validators.validateUrl;
            break;
          case 'urlnotrequired':
            validator = Validators.validateUrlNotRequired;
            break;
        }
      }
      fields.add(
        field['obscure'] == null || !field['obscure']
            ? PaddedTextFormField(
                controller: field['controller'],
                labelText: field['name'] ?? 'Not defined',
                hintText: field['name'] ?? 'Not defined',
                validator: validator,
              )
            : PaddedPasswordFormField(
                controller: field['controller'],
                labelText: field['name'] ?? 'Not defined',
                hintText: field['name'] ?? 'Not defined',
                validator: validator,
              ),
      );
    }

    return Dialog(
      backgroundColor: Theme.of(context).canvasColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
      ),
      child: Container(
        width: 400.0,
        height: (content.length * 61) + 92,
        constraints: const BoxConstraints(
          maxHeight: 600.0,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    '$namedService Configuration',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 8.0),
                  ...fields,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pop(context, true);
                          }
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
