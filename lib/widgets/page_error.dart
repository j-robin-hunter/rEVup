import 'dart:convert';

import 'package:flutter/material.dart';

class PageError extends StatelessWidget {
  final String error;
  final bool allowAdmin;

  const PageError({Key? key, required this.error, this.allowAdmin = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString('lib/assets/support.json'),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        // Execute this no matter what future outcome
        String supportEmail = '';
        String supportPhone = '';
        if (snapshot.data != null) {
          Map<String, dynamic> jsonData = jsonDecode(snapshot.data!);
          supportEmail = jsonData['email'];
          supportPhone = jsonData['phone'];
        }
        return _pageError(context, supportEmail, supportPhone);
      },
    );
  }

  Widget _pageError(BuildContext context, String supportEmail, String supportPhone) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('The following unexpected error has occurred:'),
          const SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              error,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).errorColor,
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          Text('Please contact $supportEmail  $supportPhone'),
          const SizedBox(height: 15.0),
          if (allowAdmin)
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/licenseKey');
              },
              child: const Text('Admin Access'),
            )
        ],
      ),
    );
  }
}
