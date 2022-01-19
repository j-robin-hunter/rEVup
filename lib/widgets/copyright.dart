import 'package:flutter/material.dart';

class Copyright extends StatelessWidget {
  const Copyright({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50.0,
      color: Theme.of(context).highlightColor,
      child: const Center(
        child: Text(
          'Copyright © 2022 Roma Technology Limited. All rights reserved.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}
