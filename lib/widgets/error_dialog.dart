import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String error;

  const ErrorDialog({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
      ),
      contentPadding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
      content: SizedBox(
        width: 400.0,
        height: 60.0,
        child: Center(
          child: Text(error.replaceAll(RegExp(r"\[.*\] "), '')),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
