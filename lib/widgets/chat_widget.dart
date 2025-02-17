import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prezent_vica_final/blocs/user_bloc.dart';
import 'package:prezent_vica_final/services/api_service.dart';
import 'package:prezent_vica_final/services/auth_service.dart';
import 'package:prezent_vica_final/services/db_service.dart';
import 'package:prezent_vica_final/services/image_api_service.dart'; // Importuj nowy serwis do obrazów
import 'package:prezent_vica_final/widgets/loading_dog_on_chat_appbar.dart';

class ChatWidget extends StatefulWidget {
  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {

  final ApiService _apiService = ApiService();

  final TextEditingController _controller = TextEditingController();
  User? _currentUser;
  late ScrollController _scrollController; // Dodany kontroler przewijania

  @override
  void initState() {
    super.initState();
    _currentUser = AuthService().getAuth().currentUser; // Ustawienie aktualnie zalogowanego użytkownika
    _scrollController = ScrollController(); // Inicjalizacja kontrolera przewijania
  }

  // Funkcja do wysyłania wiadomości
  void _sendMessage() {
    if (_controller.text.isNotEmpty && _currentUser != null) {
      _apiService.sendMessage(_controller.text); // Przekazuj tylko tekst wiadomości
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: true, // Pozwala na automatyczne podnoszenie ekranu przy otwarciu klawiatury
      appBar: AppBar(
        title: Text('Chat'),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/chat_background.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _apiService.getMessages(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No messages yet.'));
                  }
                  final messages = snapshot.data!;

                  // Przewiń na dół po załadowaniu wiadomości
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                    }
                  });

                  return ListView.builder(
                    controller: _scrollController, // Użyj kontrolera przewijania
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isSentByMe = message['senderId'] == _currentUser!.uid;

                      bool showUsername = true;
                      if (index > 0) {
                        final previousMessage = messages[index - 1];
                        if (previousMessage['senderId'] == message['senderId']) {
                          showUsername = false;
                        }
                      }

                      return Container(
                        margin: EdgeInsets.only(
                          top: showUsername ? 10 : 2,
                          bottom: 2,
                          left: isSentByMe ? 30 : 10,
                          right: isSentByMe ? 10 : 30,
                        ),
                        alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            if (showUsername)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  message['username'] ?? 'Unknown',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            Container(
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.yellow[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                message['text'] ?? '',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(hintText: 'Buziaki :*'),
                      style: TextStyle(color: Colors.white),
                      // Dodaj focus listener, aby przesunąć widok przy otwieraniu klawiatury
                      onTap: () {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    color: Colors.white,
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Zwolnij kontroler przewijania
    super.dispose();
  }
}
