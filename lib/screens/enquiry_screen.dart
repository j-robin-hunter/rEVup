import 'package:flutter/material.dart';
import 'package:revup/forms/enquiry_form.dart';

class EnquiryScreen extends StatelessWidget {
  const EnquiryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enquiry'),
      ),
      body: const EnquiryForm(),
    );
  }
}
