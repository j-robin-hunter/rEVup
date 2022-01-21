import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revup/models/profile.dart';
import 'package:revup/services/auth_service.dart';
import 'package:revup/services/firebase_firestore_service.dart';
import 'package:revup/widgets/page_template.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthService _authService = Provider.of<AuthService>(context);
    FirebaseFirestoreService _firebaseFirestoreService = Provider.of<FirebaseFirestoreService>(context);

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: _authService.user,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _error(context, 'Unable to load application status.');
            } else if (snapshot.hasData) {
              List? list = snapshot.data as List?;
              User? user = list![0];
              Future<Profile> profile = _firebaseFirestoreService.getProfile(user != null ? user.email! : '');
              return FutureBuilder(
                future: profile,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return PageTemplate(
                      action: _welcome(user, context),
                      body: _homeBodyScreen(context, user, _authService),
                      topImage: false,
                    );
                  } else if (snapshot.hasError) {
                    return _error(context, 'Unable to load profile data.');
                  } else {
                    return _waiting('Please wait ... loading profile');
                  }
                },
              );
            } else {
              return _waiting('Please wait ... checking application status');
            }
          },
        ),
      ),
    );
  }

  Widget _homeBodyScreen(BuildContext context, User? user, AuthService authService) {
    return Card(
      elevation: 10,
      child: SingleChildScrollView(
        child: Container(
          height: 400.0,
          constraints: const BoxConstraints(
            minWidth: 400,
            maxWidth: 800,
          ),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(3.0),
            ),
            image: DecorationImage(
              image: AssetImage('lib/assets/images/earth.png'),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.centerLeft,
          // align your child's position.
          child: Padding(
            padding: const EdgeInsets.only(left: 50.0),
            child: SizedBox(
              width: 294.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      height: 40.0,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/enquiry');
                        },
                        child: const Text('Enquire'),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    SizedBox(
                      width: double.infinity,
                      height: 40.0,
                      child: ElevatedButton(
                        onPressed: () async {},
                        child: const Text('Request a Quote'),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    SizedBox(
                      width: double.infinity,
                      height: 40.0,
                      child: ElevatedButton(
                        onPressed: () async {},
                        child: const Text('Get Support'),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    SizedBox(
                      width: double.infinity,
                      height: 40.0,
                      child: user == null || user.emailVerified == false
                          ? ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child: const Text('Login'),
                            )
                          : TextButton(
                              onPressed: () {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return _logoutDialog(context, authService);
                                  },
                                );
                              },
                              child: const Text('logout'),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _welcome(User? user, BuildContext context) {
    return user == null || user.emailVerified == false
        ? const SizedBox.shrink()
        : InkWell(
            mouseCursor: SystemMouseCursors.click,
            onTap: () {
              Navigator.pushNamed(context, '/profile', arguments: user);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (user.photoURL != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(user.photoURL!),
                    ),
                  ),
                user.displayName != null
                    ? Text(
                        'Hi ${user.displayName}',
                        style: const TextStyle(color: Colors.white),
                      )
                    : Text(
                        'Hi ${user.email}',
                        style: const TextStyle(color: Colors.white),
                      ),
              ],
            ),
          );
  }

  Widget _error(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('The following unexpected error has occurred:'),
          const SizedBox(height: 5.0),
          Text(
            error,
            style: TextStyle(
              color: Theme.of(context).errorColor,
            ),
          ),
          const SizedBox(height: 15.0),
          const Text('Please contact technical@romatech.co.uk'),
        ],
      ),
    );
  }

  Widget _waiting(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            width: 40.0,
            height: 40.0,
            child: CircularProgressIndicator(),
          ),
          const SizedBox(height: 10.0),
          Text(message),
        ],
      ),
    );
  }

  Widget _logoutDialog(BuildContext context, AuthService _auth) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
      ),
      contentPadding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
      content: const SizedBox(
        width: 400.0,
        height: 60.0,
        child: Center(child: Text('Do you really want to logout?')),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('No'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('Yes'),
          onPressed: () async {
            await _auth.signOut();
            Navigator.pushNamed(context, '/');
          },
        ),
      ],
    );
  }
}
