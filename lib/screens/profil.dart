import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tp2_dev_mobile/models/auth.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  @override
  Widget build(BuildContext context) {
    var authContext = context.watch<AuthModel>();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Profil'),
        ),
        body: FutureBuilder(
          future: getDefaultData(authContext),
          builder: (context, AsyncSnapshot<UserData> snapshot) {
            UserData? user_data = snapshot.data;
            if (snapshot.hasData && user_data != null) {
              return Container(
                  padding: const EdgeInsets.all(20),
                  child: Wrap(runSpacing: 10, children: [
                    TextFormField(
                        initialValue: user_data.email,
                        enabled: false,
                        decoration: const InputDecoration(
                          labelText: 'email',
                          isDense: true,
                        )),
                    TextFormField(
                      initialValue: user_data.password,
                      obscureText: true,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'password',
                        isDense: true,
                      ),
                      onChanged: (value) {
                        user_data.password = value.toString();
                      },
                    ),
                    InputDatePickerFormField(
                      initialDate: DateTime.parse(user_data.birth),
                      firstDate: DateTime(1970),
                      lastDate: DateTime.now(),
                      onDateSaved: (date) {
                        user_data.birth = date.toString();
                      },
                    ),
                    TextFormField(
                      initialValue: user_data.address,
                      decoration: const InputDecoration(
                        labelText: 'address',
                        isDense: true,
                      ),
                      onChanged: (value) {
                        user_data.address = value.toString();
                      },
                    ),
                    TextFormField(
                      initialValue: user_data.postcode,
                      decoration: const InputDecoration(
                        labelText: 'postcode',
                        isDense: true,
                      ),
                      onChanged: (value) {
                        user_data.postcode = value.toString();
                      },
                    ),
                    TextFormField(
                      initialValue: user_data.city,
                      decoration: const InputDecoration(
                        labelText: 'city',
                        isDense: true,
                      ),
                      onChanged: (value) {
                        user_data.city = value.toString();
                      },
                    ),
                    Wrap(
                      runSpacing: 10,
                      spacing: 10,
                      direction: Axis.horizontal,
                      children: [
                        ElevatedButton(
                          onPressed: () => submit(authContext, user_data),
                          child: const Text('Valider'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            minimumSize: Size(
                                (MediaQuery.of(context).size.width - 50) / 2,
                                30),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => logOut(authContext),
                          child: const Text('Se déconnecter'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red[800],
                            padding: const EdgeInsets.all(16),
                            minimumSize: Size(
                                (MediaQuery.of(context).size.width - 50) / 2,
                                30),
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
        ));
  }

  logOut(AuthModel authContext) {
    FirebaseAuth.instance.signOut();
    authContext.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  submit(AuthModel authContext, UserData user_data) async {
    FocusScope.of(context).unfocus();

    var userUID = authContext.user?.uid ?? '';

    await FirebaseFirestore.instance.collection('users').doc(userUID).update({
      'address': user_data.address,
      'birth': user_data.birth,
      'city': user_data.city,
      'postcode': user_data.postcode,
    }).then((_) {
      print('res: profile updated');
    }).catchError((error) {
      print('res: error: $error');
    });
  }

  Future<UserData> getDefaultData(AuthModel authContext) async {
    var userUID = authContext.user?.uid ?? '';
    var userEmail = authContext.user?.email ?? '';
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
