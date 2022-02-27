//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';
import 'package:revup/screens/license_screen.dart';
import 'package:revup/widgets/future_dialog.dart';

class EmailTemplateForm extends StatefulWidget {
  final Function callback;

  const EmailTemplateForm({Key? key, required this.callback}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EmailTemplateFormState();
  }
}

class EmailTemplateFormState extends State<EmailTemplateForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool changed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        onChanged: () {
          if (!changed) {
            setState(() => changed = true);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: 36.0,
                      child: ElevatedButton(
                        child: changed == false ? const Text('Done') : const Text('Save'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (!changed) {
                              _setFormDone();
                            } else {
                              _saveTemplates(context);
                            }
                          }
                        },
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

  void _saveTemplates(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return FutureDialog(
          future: Future.wait([
            Future.delayed(const Duration(seconds: 1), () => 0), // to allow dialog to be seen
          ]),
          waitingString: 'Saving templates ...',
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
      setState(() => changed = false);
    }); // leave settings if save is OK
  }

  void _setFormDone() {
    widget.callback(AdminStep.templates);
  }
}
