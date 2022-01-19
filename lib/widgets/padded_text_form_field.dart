import 'package:flutter/material.dart';

class PaddedTextFormField extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Function(String?)? validator;
  final TextEditingController controller;
  final String? labelText;
  final FloatingLabelBehavior floatingLabelBehavior;
  final String? hintText;
  final Icon? icon;
  final FocusNode? focusNode;
  final Function(String?)? onSaved;

  const PaddedTextFormField({
    Key? key,
    required this.controller,
    this.validator,
    this.labelText,
    this.padding = const EdgeInsets.fromLTRB(0.0, 0, 0.0, 10.0),
    this.floatingLabelBehavior = FloatingLabelBehavior.auto,
    this.hintText,
    this.icon,
    this.focusNode,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        focusNode: focusNode,
        validator: (value) => validator == null ? null : validator!(value),
        controller: controller,
        onSaved: onSaved,
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          labelText: labelText,
          floatingLabelBehavior: floatingLabelBehavior,
          prefixIcon: icon,
        ),
      ),
    );
  }
}
