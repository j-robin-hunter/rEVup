import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revup/classes/validators.dart';
import 'package:revup/extensions/string_casing_extension.dart';
import 'package:revup/services/auth_service.dart';
import 'package:revup/widgets/error_dialog.dart';
import 'package:revup/widgets/padded_password_form_field.dart';
import 'package:revup/widgets/padded_text_form_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RegisterFormState();
  }
}

class RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _name.addListener(() => _name.value = _name.value.copyWith(text: _name.text.toLowerCase().toTitleCase()));
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthService _authService = Provider.of<AuthService>(context);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PaddedTextFormField(
            controller: _name,
            validator: Validators.validateNotEmpty,
            labelText: 'Your name',
            floatingLabelBehavior: FloatingLabelBehavior.never,
            icon: const Icon(Icons.person),
            focusNode: _focusNode,
          ),
          PaddedTextFormField(
            controller: _email,
            validator: Validators.validateEmail,
            labelText: 'Email',
            floatingLabelBehavior: FloatingLabelBehavior.never,
            icon: const Icon(Icons.email),
          ),
          PaddedPasswordFormField(
            controller: _password,
            labelText: 'Password',
            floatingLabelBehavior: FloatingLabelBehavior.never,
            icon: const Icon(Icons.lock),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(
              'Password must be at least 8 characters in length, contain at least: one uppercase letter, one lowercase letter, one number and one special character',
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontSize: 10.0,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 40.0,
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    User? user = await _authService.createUserWithEmailAndPassword(_email.text, _password.text);
                    await _authService.updateUserDisplayName(user!, _name.text);
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return _createdDialog(context);
                      },
                    );
                  } catch (e) {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(error: e.toString());
                      },
                    );
                  }
                }
              },
              child: const Text('Sign up'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createdDialog(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
      ),
      contentPadding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
      content: const SizedBox(
        width: 400.0,
        height: 60.0,
        child: Center(
          child: Text('Your account has been created but will need to be verified before you will be able to login. A verification email has been sent to you.'),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
        ),
      ],
    );
  }
}
