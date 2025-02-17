// services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:prezent_vica_final/models/user.dart';
import 'package:prezent_vica_final/blocs/user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  FirebaseAuth getAuth() {
      final auth = _auth;
      return auth;
  }

  //Create new user
  Future<void> signUpUser(String email, String password,) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password.trim(),);
      final User? firebaseUser = userCredential.user;
      // if (firebaseUser != null) {
      //   return UserModel(
      //     id: firebaseUser.uid,
      //     email: firebaseUser.email ?? '',
      //     username: firebaseUser.displayName ?? '',
      //     pairedId: ''
      //   );
      // }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
    return null;
  }

  //Loggin user in
  Future<void> loginUser(String email, String password, BuildContext context) async {
    try {
      /* final UserCredential userCredential = */await _auth.signInWithEmailAndPassword(email: email, password: password);
      // Ustaw użytkownika w bloc
      // final user = UserModel(
      //     id: userCredential.user!.uid,
      //     username: email.split('@')[0], // Przykładowa metoda do uzyskania nazwy użytkownika
      //     email: email,
      //     pairedId: ''
      // );
      // Update UserBloc
      //BlocProvider.of<UserBloc>(context).setUser(user);
      // Push to home page if logging in succeded
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) { //TODO!!!
      // Else print error
      print(e.toString());
    }
  }


  //Logout user
  Future<void> logOutUser(BuildContext context) async {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseAuth.instance.signOut();
    }
    //BlocProvider.of<UserBloc>(context).clearUser();
    Navigator.pushReplacementNamed(context, '/login');
  }

}
