import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Firebase Auth class to handle user authentication
class AuthActions {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User> handleSignInEmail(String email, String password) async {
    UserCredential result =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    final User user = result.user!;

    return user;
  }

  Future<User> handleSignUpEmail(String email, String password) async {
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final User user = result.user!;

    return user;
  }

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
