import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prezent_vica_final/views/chat_screen/chat_screen.dart';
import 'package:prezent_vica_final/views/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prezent_vica_final/blocs/user_bloc.dart'; // Dodaj ten import
import 'package:prezent_vica_final/models/user.dart';
import 'package:prezent_vica_final/widgets/image_display_widget.dart';

class LoginScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _loginUser(String email, String password, BuildContext context) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      // Ustaw użytkownika w bloc
      final user = UserModel(
        uid: userCredential.user!.uid,
        username: email.split('@')[0], // Przykładowa metoda do uzyskania nazwy użytkownika
        email: email,
      );

      // Zaktualizuj UserBloc
      BlocProvider.of<UserBloc>(context).setUser(user);

      // Przejdź do ekranu głównego po zalogowaniu
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // Wyświetl komunikat o błędzie
      final snackBar = SnackBar(content: Text('Logowanie nie powiodło się: ${e}'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logsin'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _loginUser('VicaPika@ex.com', 'dsajdbh783d728bdiba89g2d7a2dbuasd', context),
              child: Text('Jestem Vica!'),
            ),
            ElevatedButton(
              onPressed: () => _loginUser('Piner@ex.com', 'sd98asyd82nbd9pa8oshd892dba8sdha8dbn', context),
              child: Text('Jestem Piner!'),
            ),
          ],
        ),
      ),
    );
  }
}
