import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revup/forms/enquiry_form.dart';
import 'package:revup/models/cms_content.dart';

class EnquiryScreen extends StatelessWidget {
  const EnquiryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cms = Provider.of<Map<String, CmsContent>>(context);
    String _email = 'email@not.set';
    try {
      final arguments = ModalRoute
          .of(context)!
          .settings
          .arguments as Map;
      _email = arguments['email'];
    } catch (e) {
      // leave email as default not set
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enquiry'),
      ),
      body: cms.isEmpty ? const CircularProgressIndicator() : EnquiryForm(_email),
    );
  }
}
