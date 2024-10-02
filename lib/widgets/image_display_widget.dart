import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prezent_vica_final/services/photo_service.dart'; // Dodajemy serwis do obsługi zdjęć
import 'loading_dog.dart';

class ImageDisplayWidget extends StatefulWidget {
  @override
  _ImageDisplayWidgetState createState() => _ImageDisplayWidgetState();
}

class _ImageDisplayWidgetState extends State<ImageDisplayWidget> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final PhotoService _photoService = PhotoService(); // Inicjalizujemy PhotoService

  // Pobieranie najnowszego zdjęcia, które nie zostało wysłane przez aktualnego użytkownika
  Future<String?> _getLatestImageUrl() async {
    try {
      final userId = _auth.currentUser?.uid;
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Pobieramy szerokość ekranu
    final imageSize = screenWidth * 0.9; // Obliczamy 90% szerokości ekranu

    return Stack(
      alignment: Alignment.center, // Ustawienie elementów na środku
      children: [
        FutureBuilder<String?>(
          future: _getLatestImageUrl(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingDog();
            } else if (snapshot.hasData) {
              return Container(
                margin: EdgeInsets.all(10),
                width: imageSize, // Kwadratowe zdjęcie o szerokości 90% ekranu
                height: imageSize,
                child: Image.network(snapshot.data!, fit: BoxFit.cover),
              );
            } else {
              return Text('No image uploaded yet.');
            }
          },
        ),
        Positioned(
          bottom: imageSize * 0.05, // Ustawienie przycisku 5% od dolnej krawędzi zdjęcia
          child: IconButton(
            icon: Icon(Icons.camera_alt_rounded, size: 40, color: Colors.white), // Powiększamy ikonę i dodajemy biały kolor
            onPressed: () async {
              // Otwórz aparat i prześlij zdjęcie
              await _photoService.pickAndUploadImage();
            },
          ),
        ),
      ],
    );
  }
}
