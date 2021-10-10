import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/login.dart';
import 'pages/home.dart';

void main() async {
  //Wait Firebase is fully initialized before starting the app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //logged boolean and Firebase user state
  bool loggedIn = true;
  User? user;

  /// Method to set the loggedIn and user state
  void login(User u) {
    setState(() {
      loggedIn = true;
      user = u;
    });
    print('UUID: ${user?.uid}');
    print('logged in !');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Vinted',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home:
            (loggedIn) // if logged in go to liste_vetements page else go to login page
                ? const Home()
                : Login(login: (user) => login(user)));
  }
}
