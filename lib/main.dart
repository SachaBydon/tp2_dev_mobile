import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:tp2_dev_mobile/models/auth.dart';
import 'package:tp2_dev_mobile/screens/login.dart';
import 'package:tp2_dev_mobile/screens/new_home.dart';
import 'package:tp2_dev_mobile/screens/home.dart';

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
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => AuthModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Vinted',
        initialRoute: '/login',
        routes: {
          // '/login': (context) => const Login(),
          '/login': (context) => const NewHome(),
          '/home': (context) => const Home(),
        },
      ),
    );
  }
}
