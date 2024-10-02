import 'package:flutter/material.dart';


class LoadingDog extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    final screenWidth = MediaQuery.of(context).size.width; // Pobieramy szerokość ekranu
    final imageSize = screenWidth * 0.9; // Obliczamy 90% szerokości ekranu
    return Center(
      child: Container(
        width: imageSize,
        height: imageSize,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/chat_appbar_dog.gif'),
            fit: BoxFit.contain, // Możesz zmienić na BoxFit.cover, jeśli chcesz, by obraz wypełniał cały kontener
          ),
        ),
      ),
    );
  }
}