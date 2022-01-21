import 'package:flutter/material.dart';
import 'package:revup/forms/enquiry_form.dart';
import 'package:revup/widgets/page_template.dart';

class EnquiryScreen extends StatelessWidget {
  const EnquiryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: PageTemplate(
          body: EnquiryForm(),
        ),
      ),
    );
  }
}
