// services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithOption1() async {
    // Logika dla opcji 1, np. logowanie za pomocą Google
    print('Sign in with Option 1');
  }

  Future<void> signInWithOption2() async {
    // Logika dla opcji 2, np. logowanie za pomocą email/password
    print('Sign in with Option 2');
  }
}
