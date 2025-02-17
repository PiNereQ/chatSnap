import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prezent_vica_final/services/auth_service.dart';
import 'package:prezent_vica_final/blocs/user_bloc.dart';
import 'package:prezent_vica_final/models/user.dart';
import 'package:prezent_vica_final/widgets/image_display_widget.dart'; // Nowy widget do wyświetlania zdjęć
import '../widgets/chat_widget.dart'; // Istniejący widget chat
import 'package:prezent_vica_final/services/photo_service.dart'; // Nowy serwis do obsługi zdjęć

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Column(
        children: [
          SizedBox(height: 10),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              AuthService().logOutUser(context);
            },
          ),
          
          SizedBox(height: 10),
          // Górna część - wyświetlanie zdjęcia i przycisk aparatu
          ImageDisplayWidget(), // Widget odpowiedzialny za wyświetlanie zdjęć z Firebase
          //Tekst powitalny użytkownika
          //   BlocBuilder<UserBloc, UserModel?>(
          //     builder: (context, user) {
          //       if (user == null) {
          //         return Text('No user logged in.');
          //       }
          //       return Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Text('Welcome, ${user.username}'),
          //       );
          //     },
          //   ),
          // Dolna część - Scrollowalny chat
          Expanded(
            child: ChatWidget(), // Dodajemy widok chatu poniżej
          ),
        ],
      ),
    );
  }
}


