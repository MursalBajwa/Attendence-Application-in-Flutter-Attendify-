import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:attendify/crDashboard.dart';
import 'package:attendify/login.dart';
import 'package:attendify/Theme/appTheme.dart';
import 'package:attendify/util/appRoutes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final isLoggedIn = snapshot.hasData;
        return MaterialApp(
          title: 'Attendify',
          themeMode: ThemeMode.light,
          theme: MyAppTheme.lightTheme,
          darkTheme: MyAppTheme.darkTheme,
        
          home: isLoggedIn ? CrDashboard() :  LoginPage(),
  
          onGenerateRoute: appRoutes.generateRoute,
        );
      },
    );
  }
}
