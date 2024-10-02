import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:prezent_vica_final/views/home_screen.dart';
import 'firebase_options.dart';
import 'package:prezent_vica_final/views/login_screen.dart';
import 'package:prezent_vica_final/blocs/user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Dodaj ten import
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Inicjalizacja Firebase App Check
  await FirebaseAppCheck.instance.activate(
    //webRecaptchaSiteKey: 'twoj-klucz-site-key', // Wymagane dla Web
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserBloc()),
        // Dodaj MessageController, jeśli potrzebny
      ],
      child: MaterialApp(
        title: 'Flutter Firebase App',
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}
