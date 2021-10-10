import 'package:flutter/material.dart';
import './buy.dart';
import './basket.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vinted'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: page,
        onTap: (int index) {
          setState(() {
            page = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Acheter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
      body: getPage(),
    );
  }

  getPage() {
    if (page == 0) {
      // page Acheter
      return buy();
    } else if (page == 1) {
      // page Panier
      return basket();
    } else if (page == 2) {
      // page Profil
      return const Center(child: Text('TODO: Profil'));
    }
  }
}
