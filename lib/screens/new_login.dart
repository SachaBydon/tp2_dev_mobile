import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:tp2_dev_mobile/models/auth.dart';
import 'package:tp2_dev_mobile/screens/home.dart';

class NewLogin extends StatefulWidget {
  //Function to be called when the user is logged in
  // final Function login;

  const NewLogin({
    Key? key,
    /*required this.login*/
  }) : super(key: key);

  @override
  _NewLoginState createState() => _NewLoginState();
}

class _NewLoginState extends State<NewLogin> {
  //Form state
  final _formKey = GlobalKey<FormState>();
  final List<String?> textFieldsValue = [];
  String _loginValue = '';
  String _passwordValue = '';

  //Firebase authentication instance
  var authHandler = Auth();

  /// Method to check if the form is valid and if it is log the user in
  submitForm(AuthModel authContext) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      checkAuth(
          _loginValue, _passwordValue, context, authContext.login, authHandler);
    }
  }

  @override
  Widget build(BuildContext context) {
    var authContext = context.watch<AuthModel>();

    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SizedBox(
            height: double.infinity,
            child: Wrap(runAlignment: WrapAlignment.end, children: [
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(40),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Connexion',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Wrap(
                            runSpacing: 16,
                            runAlignment: WrapAlignment.center,
                            children: <Widget>[
                              TextFormField(
                                validator: (value) {
                                  if (value == '') {
                                    return 'Entrez une adresse mail valide';
                                  } else {
                                    _loginValue = value.toString();
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  labelText: 'Email',
                                ),
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value == '') {
                                    return 'Entrez votre mot de passe';
                                  } else {
                                    _passwordValue = value.toString();
                                    return null;
                                  }
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  labelText: 'Mot de passe',
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => submitForm(authContext),
                                child: const Text('Se connecter',
                                    style: TextStyle(fontSize: 16)),
                                style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.only(
                                      bottom: 18, top: 18),
                                  minimumSize: const Size(double.infinity, 30),
                                ),
                              ),
                            ]),
                      ),
                      SizedBox(height: 15),
                      InkWell(
                        onTap: () => {print('mdp oublié')},
                        child: Text(
                          'Mot de passe oublié ?',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 50),
                      Center(
                          child: InkWell(
                        onTap: () => {print('créer un compte')},
                        child: Column(
                          children: [
                            Text('Vous n\'avez pas de compte ?',
                                style: TextStyle(color: Colors.grey[600])),
                            Text('Créer un compte',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ))
                    ],
                  ))
            ])));
  }

  Future<void> checkAuth(
      loginValue, passwordValue, context, login, authHandler) async {
    authHandler.handleSignInEmail(loginValue, passwordValue).then((user) {
      //Authentication successful
      login(user);
      Navigator.pushReplacementNamed(context, '/home');
    }).catchError((e) {
      //Authentication failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().split('] ')[1])),
      );
    });
  }
}

//Firebase Auth class to handle user authentication
class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User> handleSignInEmail(String email, String password) async {
    UserCredential result =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    final User user = result.user!;

    return user;
  }
}
