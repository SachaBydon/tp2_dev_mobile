import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

const colorGreen = Color(0xff26AE60);

class NewHome extends StatefulWidget {
  const NewHome({Key? key}) : super(key: key);

  @override
  _NewHomeState createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: const <Widget>[
          TopBar(),
        ],
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40, bottom: 20, left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              child: const CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('images/profile.png'),
          )),
          IconButton(
            onPressed: () {},
            icon: Badge(
                badgeColor: colorGreen,
                badgeContent:
                    const Text('3', style: TextStyle(color: Colors.white)),
                child: const Icon(
                  Icons.shopping_cart,
                )),
          ),
        ],
      ),
    );
  }
}
