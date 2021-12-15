import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revup/services/auth_service.dart';

class EmailScreen extends StatelessWidget {
  const EmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'email'
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              var isRegistered = await authService.isRegisteredUser(emailController.text);
              if (isRegistered) {
                Navigator.popAndPushNamed(context, '/login', arguments: {'email': emailController.text});
              } else {
                Navigator.popAndPushNamed(context, '/enquiry', arguments: {'email': emailController.text});
              }
            },
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}
