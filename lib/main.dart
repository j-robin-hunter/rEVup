import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:revup/screens/login_screen.dart';
import 'package:revup/screens/register_screen.dart';
import 'package:revup/services/auth_service.dart';
import 'package:revup/services/cloud_firestore_service.dart';
import 'package:revup/widgets/firebase_initialize.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<CloudFirestoreService>(
          create: (_) => CloudFirestoreService(),
        ),
      ],
      child: MaterialApp(
          title: 'rEVup',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => FirebaseInitialize(),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
          }),
    );
  }
}
