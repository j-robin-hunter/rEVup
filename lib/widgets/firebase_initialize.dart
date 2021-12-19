import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revup/widgets/auth_wrapper.dart';

class FirebaseInitialize extends StatelessWidget {
  FirebaseInitialize({Key? key}) : super(key: key);

  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureProvider(
      create: (context) => _firebaseApp,
      initialData: null,
      child: const AuthWrapper(),
    );
    /*
    return FutureBuilder(
      future: _firebaseApp,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('You have an error! ${snapshot.error.toString()}');
          return const Text('Something went wrong!');
        } else if (snapshot.hasData) {
          return const AuthWrapper();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

     */
  }
}
