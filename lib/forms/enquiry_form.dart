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
import 'package:revup/services/email_service.dart';
import 'package:revup/services/license_service.dart';
import 'package:revup/widgets/padded_text_form_field.dart';

class EnquiryForm extends StatelessWidget {
  final Profile profile;

  const EnquiryForm({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final LicenseService _licenseService = Provider.of<LicenseService>(context);

    final _email = TextEditingController();
    final _name = TextEditingController();
    final _phone = TextEditingController();
    final _message = TextEditingController();
    final _content = TextEditingController();

    _email.text = profile.email;
    _name.text = profile.name;
    _phone.text = profile.phone;

    _name.addListener(() => _name.value = _name.value.copyWith(text: _name.text.toLowerCase().toTitleCase()));
    _message.addListener(() => _message.value = _message.value.copyWith(text: _message.text.toLowerCase().toCapitalized()));
    _phone.addListener(() => _phone.value = _phone.value.copyWith(text: _phone.text.replaceAll(RegExp(r'[^+(\) \d]'), '')));

    Map<String, dynamic> _enquiry = {};

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PaddedTextFormField(
                onSaved: (value) => _enquiry['email'] = value,
                controller: _email,
                validator: Validators.validateEmail,
                labelText: 'Email',
                hintText: 'Your email address'),
            PaddedTextFormField(
              onSaved: (value) => _enquiry['name'] = value,
              controller: _name,
              validator: Validators.validateNotEmpty,
              labelText: 'Name',
              hintText: 'Your name',
            ),
            PaddedTextFormField(
              onSaved: (value) => _enquiry['phone'] = value,
              labelText: 'Phone',
              hintText: 'Your phone number',
              controller: _phone,
              validator: Validators.validatePhone,
              padding: const EdgeInsets.only(bottom: 8.0),
            ),
            PaddedTextFormField(
              onSaved: (value) => _enquiry['subject'] = value,
              labelText: 'Subject',
              hintText: 'What would you like to tell us about?',
              controller: _message,
              validator: Validators.validateNotEmpty,
              padding: const EdgeInsets.only(bottom: 8.0),
            ),
            PaddedTextFormField(
              onSaved: (value) => _enquiry['message'] = value,
              controller: _content,
              minLines: 4,
              validator: Validators.validateNotEmpty,
              labelText: 'What\'s on your mind?',
              hintText: 'What\'s on your mind?',
            ),
            SizedBox(
              height: 36.0,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return _submitEnquiryDialog(context, _licenseService.emailService!, _enquiry);
                      },
                    ).then((_) {
                      Navigator.pop(context);
                    });
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

  Widget _submitEnquiryDialog(BuildContext context, EmailService emailService, Map<String, dynamic> enquiry) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
      ),
      contentPadding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
      content: SizedBox(
        width: 400.0,
        height: 80.0,
        child: Center(
          child: FutureBuilder(
              future: emailService.sendEnquiryEmail(enquiry),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: const <Widget>[
                      Text('Many thanks for contacting us.\n\nWe have received your enquiry and we will get back to you shortly.'),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return const Text('An error');
                      //'We are very sorry but an error has occurred while sending your enquiry.\n\nPlease contact us by email at ${branding.enquiryEmail}');
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        ),
      ),
      actions: <Widget>[
        TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            }),
      ],
    );
  }
}