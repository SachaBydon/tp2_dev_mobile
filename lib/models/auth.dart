import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthActions {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Connecte l'utilisateur
  Future<User> handleSignInEmail(String email, String password) async {
    UserCredential result =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    final User user = result.user!;

    return user;
  }

  // Inscrit un utilisateur
  Future<User> handleSignUpEmail(String email, String password) async {
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final User user = result.user!;

    return user;
  }

  // Enregistre l'utilisateur dans le stockage
  saveAuthData(login, password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('user_login', login);
      prefs.setString('user_password', password);
    } catch (e) {
      print(e);
    }
  }
}
