import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prezent_vica_final/models/user.dart';

class UserBloc extends Cubit<UserModel?> {
  UserBloc() : super(null); // Inicjalizacja stanu jako null

  void setUser(UserModel user) {
    emit(user); // Emituje nowy stan użytkownika
  }

  void clearUser() {
    emit(null); // Czyści stan użytkownika
  }
}
