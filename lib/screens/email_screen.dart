import 'package:flutter/material.dart';
import 'package:revup/widgets/padded_text_form_field.dart';
import 'package:revup/classes/validators.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EmailScreenState();
  }
}

class EmailScreenState extends State<EmailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PaddedTextFormField(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                validator: (value) => Validators.validateEmail(value),
                controller: emailController,
                labelText: 'EMail',
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  /*
                  var isRegistered = await authService.isRegisteredUser(emailController.text);
                  if (isRegistered) {
                    Navigator.popAndPushNamed(context, '/login', arguments: {'email': emailController.text});
                  } else {
                    Navigator.popAndPushNamed(context, '/enquiry', arguments: {'email': emailController.text});
                  }

                   */
                }
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
