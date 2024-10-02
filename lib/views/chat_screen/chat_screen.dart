import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prezent_vica_final/services/api_service.dart';
import 'package:prezent_vica_final/services/image_api_service.dart'; // Importuj nowy serwis do obrazów

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ApiService _apiService = ApiService();
  final ImageApiService _imageApiService = ImageApiService(); // Nowa instancja serwisu do obrazów
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _controller = TextEditingController();
  User? _currentUser;
  late ScrollController _scrollController; // Dodany kontroler przewijania

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser; // Ustawienie aktualnie zalogowanego użytkownika
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
      appBar: AppBar(
        title: Text('Chat'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
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
