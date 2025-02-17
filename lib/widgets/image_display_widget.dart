import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prezent_vica_final/services/photo_service.dart'; // Dodajemy serwis do obsługi zdjęć
import 'package:prezent_vica_final/services/db_service.dart';
import 'loading_dog.dart';

class ImageDisplayWidget extends StatefulWidget {
  @override
  _ImageDisplayWidgetState createState() => _ImageDisplayWidgetState();
}

class _ImageDisplayWidgetState extends State<ImageDisplayWidget> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final PhotoService _photoService = PhotoService(); // Inicjalizujemy PhotoService
  final Future<String?> _latestImageUrl = DbService().getLatestImageUrl();



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Pobieramy szerokość ekranu
    final imageSize = screenWidth * 0.9; // Obliczamy 90% szerokości ekranu

    return Stack(
      alignment: Alignment.center, // Ustawienie elementów na środku
      children: [
        FutureBuilder<String?>(
          future: _latestImageUrl,
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
              return Stack(
                alignment: Alignment.center,
                children: [
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
          },
        ),
        Positioned(
          bottom: imageSize * 0.05, // Ustawienie przycisku 5% od dolnej krawędzi zdjęcia
          child: IconButton(
            icon: Icon(Icons.camera_alt_rounded, size: 40, color: Colors.black), // Powiększamy ikonę i dodajemy biały kolor
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
