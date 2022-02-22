//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:revup/models/license.dart';
import 'package:revup/screens/enquiry_screen.dart';
import 'package:revup/screens/home_screen.dart';
import 'package:revup/screens/license_key_screen.dart';
import 'package:revup/screens/login_screen.dart';
import 'package:revup/screens/not_started_screen.dart';
import 'package:revup/screens/quote_screen.dart';
import 'package:revup/screens/setup_screen.dart';
import 'package:revup/screens/register_screen.dart';
import 'package:revup/services/auth_service.dart';
import 'package:revup/services/environment_service.dart';
import 'package:revup/services/license_service.dart';
import 'package:revup/services/profile_service.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
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
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<EnvironmentService>(
          create: (_) => EnvironmentService(),
        ),
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<ProfileService>(
          create: (_) => ProfileService(),
        ),
        ChangeNotifierProvider<LicenseService>(
          create: (_) => LicenseService(),
        ),
      ],
      child: const TheApplication(),
    );
  }
}

class TheApplication extends StatelessWidget {
  const TheApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        Provider.of<EnvironmentService>(context).loadEnvironment(),
        Provider.of<LicenseService>(context).loadLicense(),
      ]),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          License license = snapshot.data[1] as License;
          return MaterialApp(
            title: 'rEVup',
            theme: license.branding.themeData,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
            ],
            initialRoute: license.created == null ? '/licenseKey' : '/',
            //onGenerateRoute: (route) => onGenerateRoute(route),
            routes: {
              '/': (context) => const HomeScreen(),
              '/login': (context) => const LoginScreen(),
              '/enquiry': (context) => const EnquiryScreen(),
              '/quote': (context) => const QuoteScreen(),
              '/register': (context) => const RegisterScreen(),
              '/setup': (context) => const SetupScreen(),
              '/licenseKey': (context) => const LicenseKeyScreen(),
            },
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            title: 'rEVup',
            home: NotStartedScreen(error: snapshot.error.toString()),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
