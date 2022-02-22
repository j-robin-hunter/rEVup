//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';
import 'package:revup/widgets/page_error.dart';

class NotStartedScreen extends StatelessWidget {
  final String error;
  const NotStartedScreen({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: PageError(error: error, allowAdmin: false),
        ),
    );
  }
}