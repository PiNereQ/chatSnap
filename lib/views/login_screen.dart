import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prezent_vica_final/services/auth_service.dart';
import 'package:prezent_vica_final/services/db_service.dart';
import 'package:prezent_vica_final/widgets/chat_widget.dart';
import 'package:prezent_vica_final/views/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prezent_vica_final/blocs/user_bloc.dart'; // Dodaj ten import
import 'package:prezent_vica_final/models/user.dart';
import 'package:prezent_vica_final/widgets/image_display_widget.dart';


class LoginScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Loggin user in
  Future<void> _loginUser(String email, String password, BuildContext context) async {
    try {
      AuthService().loginUser(email, password, context);
    } catch (e) {
      // Else print error
      //TODO !!!
      final snackBar = SnackBar(content: Text('Logowanie nie powiodło się: ${e}'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // BlocBuilder<UserBloc, UserModel?>(
            //   builder: (context, user) {
            //     if (user == null) {
            //       return Text('No user logged in.');
            //     }
            //     return Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Text('Welcome, ${user.username}'),
            //     );
            //   },
            // ),
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
