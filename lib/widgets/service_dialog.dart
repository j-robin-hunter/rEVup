//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';
import 'package:revup/widgets/padded_text_form_field.dart';

class ServiceDialog extends StatelessWidget {
  final Map content;
  final String namedService;

  const ServiceDialog({Key? key, required this.namedService, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> fields = [];
    for (var field in [...content[namedService]['dialogContent'].values]) {
      fields.add(
        PaddedTextFormField(
          controller: field['controller'],
          labelText: field['widget']['value'],
          hintText: field['widget']['value'],
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
        height: (fields.length * 61) + 92,
        constraints: const BoxConstraints(
          maxHeight: 600.0,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('$namedService Configuration',
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
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
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
    );
  }
}
