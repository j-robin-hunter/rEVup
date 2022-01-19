import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:revup/classes/validators.dart';
import 'package:revup/services/auth_service.dart';
import 'package:revup/widgets/padded_password_form_field.dart';
import 'package:revup/widgets/padded_text_form_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _resetKey = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _rememberMe = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
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
            controller: _email,
            validator: Validators.validateEmail,
            labelText: 'Email',
            floatingLabelBehavior: FloatingLabelBehavior.never,
            icon: const Icon(Icons.email),
            focusNode: _focusNode,
          ),
          PaddedPasswordFormField(
            controller: _password,
            labelText: 'Password',
            floatingLabelBehavior: FloatingLabelBehavior.never,
            icon: const Icon(Icons.lock),
          ),
          SizedBox(
            width: double.infinity,
            height: 40.0,
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    User? user = await _authService.signInWithEmailAndPassword(_email.text, _password.text, _rememberMe);
                    if (user!.emailVerified == false) {
                      await _authService.verifyEmailAddress(user);
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return _notVerifiedDialog();
                        },
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return _loginFailureDialog();
                      },
                    );
                  }
                }
              },
              child: const Text('Login'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return _passwordResetDialog(context);
                    },
                  );
                },
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Checkbox(
                value: _rememberMe,
                onChanged: (bool? value) {
                  setState(() {
                    _rememberMe = value!;
                  });
                },
              ),
              const Text(
                'Remember me',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 12.0, 0, 15.0),
            child: Text(
              'or',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 40.0,
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await _authService.signInWithGoogle(_rememberMe);
                Navigator.pop(context);
              },
              icon: const FaIcon(FontAwesomeIcons.google),
              label: const Text('Sign in with Google'),
            ),
          ),
          /*
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 12.0, 0, 15.0),
            child: Text(
              'or sign in with',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                onTap: () async {
                  await _authService.signInWithGoogle(_rememberMe);
                  Navigator.pop(context);
                },
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: const Center(
                    child: FaIcon(FontAwesomeIcons.google, color: Colors.white),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {},
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: const Center(
                    child: FaIcon(FontAwesomeIcons.facebookF, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
           */
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Don\'t have and account?',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginFailureDialog() {
    return AlertDialog(
      title: const Text(
        'Login Error',
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
      ),
      contentPadding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
      content: const SizedBox(
        width: 400.0,
        height: 60.0,
        child: Center(
          child: Text('The account may not exist or you may have provided an incorrect email or password'),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Retry'),
          onPressed: () {
            _password.clear();
            _focusNode.requestFocus();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _notVerifiedDialog() {
    return AlertDialog(
      title: const Text(
        'Account Not Verified',
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
      ),
      contentPadding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
      content: const SizedBox(
        width: 400.0,
        height: 60.0,
        child: Center(
          child: Text(
              'Your email has not yet been verified. An email has been sent to your email address. Please open this to verify your account and then try to login again.'),
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

  Widget _passwordResetDialog(BuildContext context) {
    AuthService _auth = Provider.of<AuthService>(context);
    TextEditingController _reset = TextEditingController();
    return AlertDialog(
      title: const Text(
        'Password Reset',
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
      ),
      contentPadding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
      content: SizedBox(
        width: 400.0,
        height: 115.0,
        child: Center(
          child: Form(
            key: _resetKey,
            child: Column(
              children: <Widget>[
                PaddedTextFormField(
                  controller: _reset,
                  validator: Validators.validateEmail,
                  labelText: 'Email',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  icon: const Icon(Icons.email),
                ),
                const Text('The password reset will send a password change email to the above email if your account is known.'),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Reset'),
          onPressed: () async {
            if (_resetKey.currentState!.validate()) {
              await _auth.resetPasswordRequest(_reset.text);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
