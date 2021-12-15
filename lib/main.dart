import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:revup/screens/email_screen.dart';
import 'package:revup/screens/enquiry_screen.dart';
import 'package:revup/screens/login_screen.dart';
import 'package:revup/screens/register_screen.dart';
import 'package:revup/services/auth_service.dart';
import 'package:revup/services/firebase_firestore_service.dart';
import 'package:revup/widgets/firebase_initialize.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBRjosGKaOhYmxCC8uM48u1UVz2KRDQeeQ",
        authDomain: "revup-62c16.firebaseapp.com",
        projectId: "revup-62c16",
        storageBucket: "revup-62c16.appspot.com",
        messagingSenderId: "412743057760",
        appId: "1:412743057760:web:bc4f1dcbc667de70acde05",
        measurementId: "G-G87WF5F2ZL"),
  );
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
        Provider<FirebaseFirestoreService>(
          create: (_) => FirebaseFirestoreService(),
        ),
      ],
      child: MaterialApp(
          title: 'rEVup',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
          ],
          initialRoute: '/',
          routes: {
            '/': (context) => FirebaseInitialize(),
            '/email': (context) => const EmailScreen(),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/enquiry': (context) => const EnquiryScreen(),
          }),
    );
  }
}
