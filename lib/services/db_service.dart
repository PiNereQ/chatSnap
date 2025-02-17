import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:prezent_vica_final/services/auth_service.dart';

class DbService {
  final FirebaseAuth _auth = AuthService().getAuth();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;


  //Download messages from db
  Stream<List<Map<String, dynamic>>> getMessages() {
    return _db.collection('messages').orderBy('timestamp').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
    );
  }


  //Add message to db
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

  // // Metoda do dodawania zdjęcia
  // Future<void> uploadImage(File image) async {
  //   final user = _auth.currentUser;
  //   String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //
  //   try {
  //     // Wysyłanie zdjęcia do Firebase Storage
  //     await _storage.ref('images/$fileName').putFile(image);
  //
  //     // Dodawanie informacji o zdjęciu do Firestore
  //     await _db.collection('images').add({
  //       'imageUrl': 'images/$fileName', // Ścieżka do obrazu
  //       'senderId': user?.uid,
  //       'timestamp': FieldValue.serverTimestamp(),
  //     });
  //   } catch (e) {
  //     print('Error uploading image: $e');
  //   }
  // }

  // Metoda do pobierania zdjęć
  // Stream<List<Map<String, dynamic>>> getImages() {
  //   return _db.collection('images').orderBy('timestamp').snapshots().map(
  //         (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
  //   );
  // }


  // Pobieranie najnowszego zdjęcia, wysłane przez sparowanego użytkownika
  Future<String?> getLatestImageUrl() async {
    try {
      final userId = _auth.currentUser?.uid;
      final pairedId = '';
      final ListResult result = await _storage.ref('images').listAll();
      final List<Reference> allFiles = result.items;

      // Filtrujemy pliki, aby wyświetlić tylko te, które nie zostały przesłane przez zalogowanego użytkownika
      List<Reference> filteredFiles = [];

      for (var file in allFiles) {
        // Pobieramy metadane pliku (w tym nadawcę)
        FullMetadata metadata = await file.getMetadata();
        String? senderId = metadata.customMetadata?['senderId'];

        // Sprawdzamy, czy plik nie został wysłany przez obecnie zalogowanego użytkownika
        if (senderId != userId) {
          filteredFiles.add(file);
        }
      }

      if (filteredFiles.isNotEmpty) {
        // Sortujemy pliki po dacie stworzenia (zakładam, że w nazwie jest timestamp lub inny mechanizm)
        filteredFiles.sort((a, b) => b.name.compareTo(a.name));

        // Zwracamy URL do najnowszego zdjęcia przesłanego przez innego użytkownika
        return await filteredFiles.first.getDownloadURL();
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

}
