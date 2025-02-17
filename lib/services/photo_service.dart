import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PhotoService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final picker = ImagePicker();

  // Funkcja do robienia zdjęcia i jego przesyłania do Firebase Storage
  Future<void> pickAndUploadImage() async {
    final String senderId = _auth.currentUser!.uid;
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString(); // Użyj timestampu jako nazwy pliku

      try {
        // Dodajemy metadane, aby wiedzieć, kto wysłał zdjęcie
        final metadata = SettableMetadata(customMetadata: {
          'senderId': senderId,
        });

        // Przesyłanie pliku do Firebase Storage
        await _storage.ref('images/$senderId/$fileName').putFile(imageFile, metadata);
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
