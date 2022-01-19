import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:revup/forms/profile_form.dart';
import 'package:revup/widgets/copyright.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? _user = ModalRoute.of(context)!.settings.arguments as User?;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 110.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/images/earth.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: 150.0,
                  height: 86.0,
                  child: Image.asset('lib/assets/images/logo-rev-230x132.png'),
                ),
              ),
            ),
            Positioned(
              top: 35.0,
              right: 10.0,
              child: SizedBox(
                height: 35.0,
                child: IconButton(
                  mouseCursor: SystemMouseCursors.click,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ),
            Center(
              child: _user == null
                  ? const Text('You are not authorised to access this page')
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      child: SingleChildScrollView(
                        child: Container(
                          height: 460.0,
                          constraints: const BoxConstraints(
                            minWidth: 400,
                            maxWidth: 800,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  'User Profile',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Container(
                                height: 400.0,
                                constraints: const BoxConstraints(
                                  minWidth: 400,
                                  maxWidth: 800,
                                ),
                                alignment: Alignment.centerLeft,
                                // align your child's position.
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ProfileForm(user: _user),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
            const Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: Copyright(),
            ),
          ],
        ),
      ),
    );
  }
}
