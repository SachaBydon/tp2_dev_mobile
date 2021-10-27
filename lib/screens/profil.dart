import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tp2_dev_mobile/models/app_state.dart';

import 'package:tp2_dev_mobile/screens/basket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final AppState appState = GetIt.instance.get<AppState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const TopBar('Profile'),
            Expanded(child: SingleChildScrollView(child: form()))
          ],
        ));
  }

  Widget form() {
    return FutureBuilder(
      future: getDefaultData(),
      builder: (context, AsyncSnapshot<UserData> snapshot) {
        UserData? userData = snapshot.data;
        if (snapshot.hasData && userData != null) {
          return Container(
              padding: const EdgeInsets.all(20),
              child: Wrap(runSpacing: 10, children: [
                TextFormField(
                    initialValue: userData.email,
                    keyboardType: TextInputType.emailAddress,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'email',
                      isDense: true,
                    )),
                TextFormField(
                  initialValue: userData.password,
                  obscureText: true,
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: 'password',
                    isDense: true,
                  ),
                  onChanged: (value) {
                    userData.password = value.toString();
                  },
                ),
                InputDatePickerFormField(
                  initialDate: DateTime.parse(userData.birth),
                  firstDate: DateTime(1970),
                  lastDate: DateTime.now(),
                  onDateSaved: (date) {
                    userData.birth = date.toString();
                  },
                ),
                TextFormField(
                  initialValue: userData.address,
                  decoration: const InputDecoration(
                    labelText: 'address',
                    isDense: true,
                  ),
                  onChanged: (value) {
                    userData.address = value.toString();
                  },
                ),
                TextFormField(
                  initialValue: userData.postcode,
                  decoration: const InputDecoration(
                    labelText: 'postcode',
                    isDense: true,
                  ),
                  onChanged: (value) {
                    userData.postcode = value.toString();
                  },
                ),
                TextFormField(
                  initialValue: userData.city,
                  decoration: const InputDecoration(
                    labelText: 'city',
                    isDense: true,
                  ),
                  onChanged: (value) {
                    userData.city = value.toString();
                  },
                ),
                Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  direction: Axis.horizontal,
                  children: [
                    ElevatedButton(
                      onPressed: () => submit(userData),
                      child: const Text('Valider'),
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: const EdgeInsets.all(16),
                        minimumSize: Size(
                            (MediaQuery.of(context).size.width - 50) / 2, 30),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => logOut(),
                      child: const Text('Se déconnecter'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red[500],
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: const EdgeInsets.all(16),
                        minimumSize: Size(
                            (MediaQuery.of(context).size.width - 50) / 2, 30),
                      ),
                    ),
                  ],
                )
              ]));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  logOut() async {
    FirebaseAuth.instance.signOut();
    appState.logout();

    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('user_login');
      prefs.remove('user_password');
    } catch (e) {
      print(e);
    }

    Navigator.pushReplacementNamed(context, '/login');
  }

  submit(UserData userData) async {
    FocusScope.of(context).unfocus();

    String userUID = appState.user?.uid ?? '';

    await FirebaseFirestore.instance.collection('users').doc(userUID).update({
      'address': userData.address,
      'birth': userData.birth,
      'city': userData.city,
      'postcode': userData.postcode,
    }).then((_) {
      print('res: profile updated');
    }).catchError((error) {
      print('res: error: $error');
    });
  }

  Future<UserData> getDefaultData() async {
    var userUID = appState.user?.uid ?? '';
    var userEmail = appState.user?.email ?? '';
    var userFakePassword = '............';

    DocumentSnapshot<Map<String, dynamic>> query =
        await FirebaseFirestore.instance.collection('users').doc(userUID).get();

    var defaultUserData = UserData(userEmail, userFakePassword, query['birth'],
        query['address'], query['postcode'], query['city']);

    return defaultUserData;
  }
}

class UserData {
  String email;
  String password;
  String birth;
  String address;
  String postcode;
  String city;

  UserData(this.email, this.password, this.birth, this.address, this.postcode,
      this.city);
}
