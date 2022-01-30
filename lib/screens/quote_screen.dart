//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';
import 'package:revup/forms/quote_form.dart';
import 'package:revup/widgets/page_template.dart';

class QuoteScreen extends StatelessWidget {
  const QuoteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return const Scaffold(
      body: SafeArea(
        child: PageTemplate(
          body: QuoteForm(),
        ),
      ),
    );
  }
}
