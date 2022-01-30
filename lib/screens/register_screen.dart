//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';
import 'package:revup/widgets/page_template.dart';
import 'package:revup/forms/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageTemplate(
          body: _registerScreenBody(),
          topImage: false,
        ),
      ),
    );
  }

  Widget _registerScreenBody() {
    return Card(
      elevation: 10,
      child: Container(
        height: 400.0,
        constraints: const BoxConstraints(
          minWidth: 400,
          maxWidth: 800,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(3.0),
          ),
          image: DecorationImage(
            image: AssetImage('lib/assets/images/earth.png'),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.centerLeft,
        // align your child's position.
        child: const Padding(
          padding: EdgeInsets.only(left: 50.0),
          child: SizedBox(
            width: 294.0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: RegisterForm(),
            ),
          ),
        ),
      ),
    );
  }
}
