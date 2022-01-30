//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';
import 'package:revup/classes/validators.dart';
import 'package:revup/models/license.dart';
import 'package:revup/widgets/padded_text_form_field.dart';

class AdminForm extends StatefulWidget {
  final License license;
  final Function callback;

  const AdminForm({Key? key, required this.license, required this.callback}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AdminFormState();
  }
}

class AdminFormState extends State<AdminForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _logoUrl = TextEditingController();
  final _administrators = TextEditingController();

  bool changed = false;

  @override
  void initState() {
    super.initState();
    _logoUrl.text = widget.license.logoUrl;
    _administrators.text = widget.license.administrators.toString();
  }

  @override
  void dispose() {
    _logoUrl.dispose();
    _administrators.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _logoUrl.addListener(() => _logoUrl.value = _logoUrl.value.copyWith(text: _logoUrl.text.toLowerCase()));
    _administrators
        .addListener(() => _administrators.value = _administrators.value.copyWith(text: _administrators.text.toLowerCase()));

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
              child: Text('License holder: ${widget.license.licensee}'),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text('Licensed from: ${widget.license.created}'),
            ),
            PaddedTextFormField(
              onSaved: (value) => widget.license.setLogoUrl(value!),
              controller: _logoUrl,
              validator: Validators.validateNotEmpty,
              labelText: 'Logo URL',
              hintText: 'URL for the logo displayed on each page',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            PaddedTextFormField(
              onSaved: (value) => widget.license.setAdministrators(value!.split(',')),
              controller: _administrators,
              validator: Validators.validateNotEmpty,
              labelText: 'Administrators',
              hintText: 'Comma list of administrator emails',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 40.0,
                      child: ElevatedButton(
                          child: const Text('OK'),
                          onPressed: () {},
                      ),
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
}
