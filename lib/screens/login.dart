import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:tp2_dev_mobile/models/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  //Function to be called when the user is logged in
  // final Function login;

  const Login({
    Key? key,
    /*required this.login*/
  }) : super(key: key);

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

  var authContext;

  /// Method to check if the form is valid and if it is log the user in
  submitForm() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      checkAuth(
          _loginValue, _passwordValue, context, authContext.login, authHandler);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (authContext == null) {
      authContext = context.watch<AuthModel>();
      getAuthData(authContext.login);
    }
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SizedBox(
            height: double.infinity,
            child: Wrap(runAlignment: WrapAlignment.end, children: [
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(40),
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
                                keyboardType: TextInputType.emailAddress,
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
                                keyboardType: TextInputType.visiblePassword,
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
                                onPressed: () => submitForm(),
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
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () => {print('mdp oublié')},
                        child: Text(
                          'Mot de passe oublié ?',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 50),
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
      saveAuthData(loginValue, passwordValue);
      Navigator.pushReplacementNamed(context, '/home');
    }).catchError((e) {
      //Authentication failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().split('] ')[1])),
      );
    });
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

  getAuthData(login) async {
    var userLogin;
    var userPassword;

    try {
      final prefs = await SharedPreferences.getInstance();
      userLogin = prefs.getString('user_login');
      userPassword = prefs.getString('user_password');
    } catch (e) {
      print(e);
    }

    if (userLogin == null || userPassword == null) return null;

    authHandler.handleSignInEmail(userLogin, userPassword).then((user) {
      //Authentication successful
      login(user);
      Navigator.pushReplacementNamed(context, '/home');
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
