import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revup/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final TextEditingController passwordController = TextEditingController();

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
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await authService.signInWithEmailAndPassword(arguments['email'], passwordController.text);
              Navigator.popAndPushNamed(context, '/');
            },
            child: const Text('Login'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}
