import 'db_service.dart';

class ApiService {
  final DbService _dbService = DbService();

  Stream<List<Map<String, dynamic>>> getMessages() {
    return _dbService.getMessages();
  }

  Future<void> sendMessage(String message) async {
    await _dbService.sendMessage(message);
  }



  
}
