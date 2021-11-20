import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import 'package:tp2_dev_mobile/models/app_state.dart';
import 'package:tp2_dev_mobile/utils.dart';
import 'package:tp2_dev_mobile/widgets/topbar.dart';

class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final AppState appState = GetIt.instance.get<AppState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
            height: double.infinity,
            child: Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const TopBar('Profile'),
                  Expanded(child: SingleChildScrollView(child: form()))
                ],
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
            ])));
  }

  TextEditingController intialdateval = TextEditingController(text: '');

  Widget form() {
    return FutureBuilder(
      future: getDefaultData(),
      builder: (context, AsyncSnapshot<UserData> snapshot) {
        UserData? userData = snapshot.data;
        if (userData?.birth != '' && userData?.birth != null) {
          intialdateval.text =
              formatDate(DateTime.parse(userData?.birth ?? ''));
        }

        if (snapshot.hasData && userData != null) {
          return Container(
              padding: const EdgeInsets.all(20),
              child: Wrap(runSpacing: 10, children: [
                TextFormField(
                  initialValue: userData.email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: textFormFieldDecoration('Email', context),
                  onChanged: (value) {
                    userData.email = value.toString();
                  },
                ),
                TextFormField(
                  initialValue: userData.password,
                  obscureText: true,
                  decoration: textFormFieldDecoration('Mot de passe', context),
                  onChanged: (value) {
                    userData.password = value.toString();
                  },
                ),
                TextFormField(
                  readOnly: true,
                  autocorrect: false,
                  maxLines: 1,
                  controller: intialdateval,
                  decoration:
                      textFormFieldDecoration('Date de naissance', context),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now());

                    if (date != null) {
                      userData.birth = date.toString();
                      intialdateval.text = formatDate(date);
                    }
                  },
                ),
                TextFormField(
                  initialValue: userData.address,
                  decoration: textFormFieldDecoration('Adresse', context),
                  onChanged: (value) {
                    userData.address = value.toString();
                  },
                ),
                TextFormField(
                  initialValue: userData.postcode,
                  keyboardType: TextInputType.number,
                  decoration: textFormFieldDecoration('Code postale', context),
                  onChanged: (value) {
                    userData.postcode = value.toString();
                  },
                ),
                TextFormField(
                  initialValue: userData.city,
                  decoration: textFormFieldDecoration('Ville', context),
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
                      child: Wrap(
                        runAlignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10,
                        children: const [
                          Icon(Icons.check),
                          Text(
                            'Valider',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff26AE60),
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.only(bottom: 14, top: 14),
                        minimumSize: Size(
                            (MediaQuery.of(context).size.width - 50) / 2, 30),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => logOut(),
                      child: Wrap(
                        runAlignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10,
                        children: const [
                          Icon(Icons.logout),
                          Text(
                            'Se déconnecter',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red.shade500,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.only(bottom: 14, top: 14),
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
    setState(() => isLoading = true);

    await FirebaseFirestore.instance.collection('users').doc(userUID).update({
      'address': userData.address,
      'birth': userData.birth,
      'city': userData.city,
      'postcode': userData.postcode,
    });

    if (userData.email != userData.previousEmail) {
      // Update email
      await appState.user?.updateEmail(userData.email);
    }

    if (userData.password != userData.previousPassword) {
      // Update password
      await appState.user?.updatePassword(userData.password);
    }

    setState(() => isLoading = false);
  }

  Future<UserData> getDefaultData() async {
    String userUID = appState.user?.uid ?? '';
    String userEmail = appState.user?.email ?? '';

    DocumentSnapshot<Map<String, dynamic>> query =
        await FirebaseFirestore.instance.collection('users').doc(userUID).get();

    var defaultUserData = UserData(userEmail, userEmail, '', '', query['birth'],
        query['address'], query['postcode'], query['city']);

    return defaultUserData;
  }
}

class UserData {
  String email;
  String previousEmail;
  String password;
  String previousPassword;

  String birth;
  String address;
  String postcode;
  String city;

  UserData(this.email, this.previousEmail, this.password, this.previousPassword,
      this.birth, this.address, this.postcode, this.city);
}

formatDate(DateTime date) {
  String day = (date.day < 10) ? '0${date.day}' : date.day.toString();
  String month = (date.month < 10) ? '0${date.month}' : date.month.toString();
  String year = date.year.toString();
  return '$day/$month/$year';
}

//Firebase Auth class to handle user authentication
// class Auth {
//   final FirebaseAuth auth = FirebaseAuth.instance;

//   Future<void> updateEmail(User user, String new_email) async {
//     await user.updateEmail(new_email);
//   }

//   Future<void> updatePassword(User user, String new_password) async {
//     await user.updatePassword(new_password);
//   }
// }
