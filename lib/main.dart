import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tp2_dev_mobile/models/auth.dart';
import 'package:tp2_dev_mobile/screens/home.dart';
import 'package:tp2_dev_mobile/screens/login.dart';
import 'package:tp2_dev_mobile/models/test_global.dart';

GetIt getIt = GetIt.instance;

void main() async {
  //Wait Firebase is fully initialized before starting the app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  getIt.registerSingleton<Counter>(Counter());
  getIt.registerSingleton<UserState>(UserState());

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
      var userLogin = prefs.getString('user_login');
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
                colorScheme: const ColorScheme.light(
                  primary: Color(0xff26AE60),
                  secondary: Color(0xff26AE60),
                ),
              ),
              routes: {
                '/login': (context) => const Login(),
                '/home': (context) => const Home(),
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
