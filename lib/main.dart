import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:revup/models/cms_content.dart';
import 'package:revup/screens/enquiry_screen.dart';
import 'package:revup/screens/home_screen.dart';
import 'package:revup/screens/login_screen.dart';
import 'package:revup/screens/profile_screen.dart';
import 'package:revup/screens/register_screen.dart';
import 'package:revup/services/auth_service.dart';
import 'package:revup/services/cms_service.dart';
import 'package:revup/services/firebase_firestore_service.dart';
import 'package:revup/services/firebase_storage_service.dart';
import 'package:revup/services/shared_preferences_service.dart';
import 'classes/create_material_color.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  setPathUrlStrategy();
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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final int airSuperiorityBlue = 0xff579aba;
  final int greenSheen = 0xff84c1c1;
  final int midGrey = 0xff777777;
  final int veryDarkGrey = 0xff2a2a2a;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<FirebaseFirestoreService>(
          create: (_) => FirebaseFirestoreService(),
        ),
        Provider<FirebaseStorageService>(
          create: (_) => FirebaseStorageService(),
        ),
        FutureProvider<Map<String, CmsContent>>(
          create: (_) => CmsService().cmsContent(),
          initialData: const {},
        ),
        Provider<SharedPreferencesService>(
          create: (_) => SharedPreferencesService(),
        ),
      ],
      child: MaterialApp(
        title: 'rEVup',
        theme: ThemeData(
          primarySwatch: createMaterialColor(Color(greenSheen)),
          secondaryHeaderColor: Color(veryDarkGrey),
          unselectedWidgetColor: Color(greenSheen),
          highlightColor: Color(midGrey),
          appBarTheme: AppBarTheme(backgroundColor: Color(airSuperiorityBlue), foregroundColor: Colors.white),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xff84c1c1),
            foregroundColor: Colors.white,
          ),
          inputDecorationTheme: InputDecorationTheme(
            isDense: true,
            labelStyle: const TextStyle(
              color: Colors.black26,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            floatingLabelStyle: TextStyle(
              color: Color(airSuperiorityBlue),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black12,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black87,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black54,
                width: 1,
              ),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black12,
                width: 1,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          errorColor: Colors.deepOrange,
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
        //onGenerateRoute: (route) => onGenerateRoute(route),
        routes: {
          '/': (context) => const HomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/enquiry': (context) => const EnquiryScreen(),
          '/register': (context) => const RegisterScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}