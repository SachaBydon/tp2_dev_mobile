import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tp2_dev_mobile/models/app_state.dart';

import 'package:tp2_dev_mobile/screens/home.dart';
import 'package:tp2_dev_mobile/screens/login.dart';
import 'package:tp2_dev_mobile/screens/signin.dart';

GetIt getIt = GetIt.instance;

//TODO: Ajouter commentaires
//TODO: Faire un rapport

void main() async {
  //Wait Firebase is fully initialized before starting the app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  getIt.registerSingleton<AppState>(AppState());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool> aslogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userLogin = prefs.getString('user_login');
      return (userLogin != null);
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: aslogin(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Vinted',
              initialRoute: (snapshot.data ?? false) ? '/home' : '/login',
              theme: ThemeData(
                canvasColor: Colors.transparent,
                colorScheme: const ColorScheme.light(
                  primary: Color(0xff02B2BB),
                  secondary: Color(0xff02B2BB),
                  secondaryVariant: Color(0xff26AE60),
                ),
              ),
              routes: {
                '/login': (context) => const Login(),
                '/signin': (context) => const Signin(),
                '/home': (context) => const Home(),
              },
            );
          } else {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              builder: (context, child) {
                return const Scaffold(
                  backgroundColor: Colors.white,
                );
              },
            );
          }
        });
  }
}
