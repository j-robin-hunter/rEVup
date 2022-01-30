//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';
import 'package:revup/forms/login_form.dart';
import 'package:revup/widgets/page_template.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageTemplate(
          body: _loginScreenBody(),
          topImage: false,
        ),
      ),
    );
  }

  Widget _loginScreenBody() {
    return Card(
      elevation: 10,
      child: SingleChildScrollView(
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
                child: LoginForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}