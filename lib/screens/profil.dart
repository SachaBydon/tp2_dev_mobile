import 'package:flutter/material.dart';

class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  var showDialog = false;

//get data from firbase auth and firestore
  var user_data = new UserData(
      'test@test.com', 'azerty', '1999-12-28', 'la bas', '06800', 'New York');

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Wrap(runSpacing: 10, children: [
          TextFormField(
            initialValue: user_data.email,
            decoration: const InputDecoration(
              labelText: 'email',
              isDense: true,
            ),
          ),
          TextFormField(
            initialValue: user_data.password,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'password',
              isDense: true,
            ),
          ),
          InputDatePickerFormField(
            initialDate: DateTime.parse(user_data.birth),
            firstDate: DateTime(1970),
            lastDate: DateTime.now(),
          ),
          TextFormField(
            initialValue: user_data.address,
            decoration: const InputDecoration(
              labelText: 'address',
              isDense: true,
            ),
          ),
          TextFormField(
            initialValue: user_data.postcode,
            decoration: const InputDecoration(
              labelText: 'postcode',
              isDense: true,
            ),
          ),
          TextFormField(
            initialValue: user_data.city,
            decoration: const InputDecoration(
              labelText: 'city',
              isDense: true,
            ),
          ),
          Wrap(
            runSpacing: 10,
            spacing: 10,
            direction: Axis.horizontal,
            children: [
              ElevatedButton(
                onPressed: () => {},
                child: const Text('Valider'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  minimumSize:
                      Size((MediaQuery.of(context).size.width - 50) / 2, 30),
                ),
              ),
              ElevatedButton(
                onPressed: () => {},
                child: const Text('Se déconnecter'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red[800],
                  padding: const EdgeInsets.all(16),
                  minimumSize:
                      Size((MediaQuery.of(context).size.width - 50) / 2, 30),
                ),
              ),
            ],
          )
        ]));
  }
}

class UserData {
  final String email;
  final String password;
  final String birth;
  final String address;
  final String postcode;
  final String city;

  UserData(this.email, this.password, this.birth, this.address, this.postcode,
      this.city);
}
