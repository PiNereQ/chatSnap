import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prezent_vica_final/services/api_service.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prezent_vica_final/services/auth_service.dart';

class MessageController extends Cubit<List<Map<String, dynamic>>> {
  final ApiService _apiService;
  final FirebaseAuth _auth = AuthService().getAuth();

  MessageController(this._apiService) : super([]);

  void fetchMessages() {
    _apiService.getMessages().listen((messages) {
      emit(messages);
    });
  }

  Future<void> sendMessage(String message) async {
    final senderId = _auth.currentUser?.uid;

    if (senderId != null) {
      await _apiService.sendMessage(message);
    } else {
      throw Exception('User not logged in');
    }
  }
}
