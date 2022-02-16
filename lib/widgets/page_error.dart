import 'package:flutter/material.dart';

class PageError extends StatelessWidget {
  final String error;

  const PageError({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('The following unexpected error has occurred:'),
          const SizedBox(height: 5.0),
          Text(
            error,
            style: TextStyle(
              color: Theme.of(context).errorColor,
            ),
          ),
          const SizedBox(height: 15.0),
          const Text('Please contact technical@romatech.co.uk'),
        ],
      ),
    );
  }
}