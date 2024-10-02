import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class DbService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;



  Stream<List<Map<String, dynamic>>> getMessages() {
    return _db.collection('messages').orderBy('timestamp').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
    );
  }

  Future<void> sendMessage(String message) async {
    final user = _auth.currentUser; // Użytkownik, który wysyła wiadomość
    String username = user?.email?.split('@')[0] ?? 'Unknown'; // Przykładowa metoda do uzyskania nazwy użytkownika

    await _db.collection('messages').add({
      'text': message,
      'senderId': user?.uid,
      'username': username, // Dodaj nazwę użytkownika do wiadomości
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Metoda do dodawania zdjęcia
  Future<void> uploadImage(File image) async {
    final user = _auth.currentUser;
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      // Wysyłanie zdjęcia do Firebase Storage
      await _storage.ref('images/$fileName').putFile(image);

      // Dodawanie informacji o zdjęciu do Firestore
      await _db.collection('images').add({
        'imageUrl': 'images/$fileName', // Ścieżka do obrazu
        'senderId': user?.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  // Metoda do pobierania zdjęć
  Stream<List<Map<String, dynamic>>> getImages() {
    return _db.collection('images').orderBy('timestamp').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
    );
  }


}
