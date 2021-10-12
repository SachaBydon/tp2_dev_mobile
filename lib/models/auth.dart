import 'package:firebase_auth/firebase_auth.dart';

class AuthModel {
  bool loggedIn = false;
  User? user;

  void login(User u) {
    loggedIn = true;
    user = u;
    print('UUID: ${user?.uid}');
    print('logged in !');
  }
}
