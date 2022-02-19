//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/material.dart';
import 'package:revup/classes/validators.dart';

class PaddedPasswordFormField extends StatefulWidget {
  final EdgeInsetsGeometry padding;
  final TextEditingController controller;
  final Function(String?)? validator;
  final String? labelText;
  final FloatingLabelBehavior floatingLabelBehavior;
  final String? hintText;
  final Icon? icon;
  final FocusNode? focusNode;

  const PaddedPasswordFormField({
    Key? key,
    required this.controller,
    this.labelText,
    this.padding = const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
    this.floatingLabelBehavior = FloatingLabelBehavior.auto,
    this.hintText,
    this.icon,
    this.focusNode,
    this.validator = Validators.validatePassword,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PaddedPasswordFormFieldState();
  }
}

class PaddedPasswordFormFieldState extends State<PaddedPasswordFormField> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: TextFormField(
        focusNode: widget.focusNode,
        validator: (value) => widget.validator!(value),
        controller: widget.controller,
        obscureText: !_showPassword,
        decoration: InputDecoration(
          isDense: true,
          hintText: widget.hintText,
          labelText: widget.labelText,
          floatingLabelBehavior: widget.floatingLabelBehavior,
          prefixIcon: widget.icon,
          suffixIcon: GestureDetector(
            onTap: () {
              _toggleVisibility();
            },
            child: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
          ),
        ),
      ),
    );
  }

  void _toggleVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }
}
