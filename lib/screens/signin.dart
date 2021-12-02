import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tp2_dev_mobile/models/auth.dart';
import 'package:tp2_dev_mobile/widgets/logo.dart';
import 'package:tp2_dev_mobile/models/app_state.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  // Données pour le formulaire
  final _formKey = GlobalKey<FormState>();
  final List<String?> textFieldsValue = [];
  String _loginValue = '';
  String _passwordValue = '';

  bool showPassword = false;
  bool showConfirm = false;

  AuthActions authHandler = AuthActions();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Container(
        margin: const EdgeInsets.only(top: 25),
        child: Stack(
          children: [
            Column(children: [
              if (MediaQuery.of(context).size.height > 300)
                Expanded(child: Logo()),
              Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).viewInsets.bottom -
                        25,
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.all(40),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Inscription',
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
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  RegExp mailRegex = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                                  if (value == '' ||
                                      !mailRegex.hasMatch(value ?? '')) {
                                    return 'Cette adresse mail n\'est pas valide';
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
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value == '') {
                                    return 'Entrez votre mot de passe';
                                  } else {
                                    _passwordValue = value.toString();
                                    return null;
                                  }
                                },
                                obscureText: !showPassword,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      icon: showPassword
                                          ? const Icon(Icons.visibility_off)
                                          : const Icon(Icons.visibility),
                                      onPressed: () => {
                                            setState(() {
                                              showPassword = !showPassword;
                                            })
                                          }),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  labelText: 'Mot de passe',
                                ),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value == '') {
                                    return 'Confirmer votre mot de passe';
                                  } else if (value != _passwordValue) {
                                    return 'Les mots de passe ne correspondent pas';
                                  }
                                },
                                obscureText: !showConfirm,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      icon: showConfirm
                                          ? const Icon(Icons.visibility_off)
                                          : const Icon(Icons.visibility),
                                      onPressed: () => {
                                            setState(() {
                                              showConfirm = !showConfirm;
                                            })
                                          }),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  labelText: 'Confirmer',
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => submitForm(),
                                child: Wrap(
                                  runAlignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 10,
                                  children: const [
                                    Icon(Icons.login),
                                    Text(
                                      'S\'inscrire',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    )
                                  ],
                                ),
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
                      const SizedBox(height: 50),
                      Center(
                          child: InkWell(
                        onTap: () => {Navigator.pushNamed(context, '/login')},
                        child: Column(
                          children: [
                            Text('Vous avez déjà un compte ?',
                                style: TextStyle(color: Colors.grey.shade600)),
                            Text('Se connecter',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ))
                    ],
                  )))
            ]),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
          ],
        ),
      ),
    );
  }

  submitForm() async {
    FocusScope.of(context).unfocus();

    // Vérifie que les champs sont remplis
    bool isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    setState(() => isLoading = true);

    Map<String, String> emptyUserData = {
      'address': '',
      'birth': '',
      'city': '',
      'postcode': '',
    };

    // Création de l'utilisateur
    try {
      User user =
          await authHandler.handleSignUpEmail(_loginValue, _passwordValue);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(emptyUserData);
      await FirebaseFirestore.instance
          .collection('paniers')
          .doc(user.uid)
          .set({'items': []});

      //Authentication réussie

      AppState appState = GetIt.instance.get<AppState>();

      // Connecte l'utilisateur
      appState.login(user);
      // Enregistre les données de l'utilisateur dans le stockage
      authHandler.saveAuthData(_loginValue, _passwordValue);
      // Redirige l'utilisateur vers la page d'accueil
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      //Authentication échouée
      String errorMessage = e.toString();
      if (errorMessage.split('] ').length > 1) {
        errorMessage = errorMessage.split('] ')[1];
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(errorMessage),
            duration: const Duration(milliseconds: 1500),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red),
      );
    }

    setState(() => isLoading = false);
  }
}
