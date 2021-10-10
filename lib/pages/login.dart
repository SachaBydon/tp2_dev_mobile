import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  //Function to be called when the user is logged in
  final Function login;

  const Login({Key? key, required this.login}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Form state
  final _formKey = GlobalKey<FormState>();
  final List<String?> textFieldsValue = [];
  String _loginValue = '';
  String _passwordValue = '';

  //Firebase authentication instance
  var authHandler = Auth();

  /// Method to check if the form is valid and if it is log the user in
  submitForm() async {
    if (_formKey.currentState!.validate()) {
      checkAuth(
          _loginValue, _passwordValue, context, widget.login, authHandler);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Connexion'),
        ),
        body: Container(
            padding: const EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height,
            child: Form(
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
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Login',
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
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: submitForm,
                      child: const Text('Se connecter',
                          style: TextStyle(fontSize: 20)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        minimumSize: const Size(double.infinity, 30),
                      ),
                    ),
                  ]),
            )));
  }

  Future<void> checkAuth(
      loginValue, passwordValue, context, login, authHandler) async {
    authHandler.handleSignInEmail(loginValue, passwordValue).then((user) {
      //Authentication successful
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentification réussi !')),
      );
      //Call the login function
      login(user);
    }).catchError((e) {
      //Authentication failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
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

  Future<User> handleSignUp(email, password) async {
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final User user = result.user!;

    return user;
  }
}
