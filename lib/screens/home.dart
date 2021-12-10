import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tp2_dev_mobile/models/auth.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tp2_dev_mobile/widgets/logo.dart';
import 'package:tp2_dev_mobile/models/app_state.dart';
import 'package:tp2_dev_mobile/models/clothe.dart';
import 'package:tp2_dev_mobile/screens/profil.dart';
import 'package:tp2_dev_mobile/screens/basket.dart';
import 'package:tp2_dev_mobile/screens/detail.dart';
import 'package:tp2_dev_mobile/screens/new_product.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List tabs = [
    {'id': 0, 'label': 'Tous'},
    {'id': 1, 'label': 'Vêtements'},
    {'id': 2, 'label': 'Accessoires'}
  ];

  AuthActions authHandler = AuthActions();
  final AppState appState = GetIt.instance.get<AppState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const NewProduct()));
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.white,
        body: FutureBuilder(
          future: getAuthData(),
          builder: (context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return DefaultTabController(
                length: tabs.length,
                child: Column(
                  children: <Widget>[
                    TopBar(),
                    ArticlesTabs(tabs),
                    const ListItems()
                  ],
                ),
              );
            }
          },
        ));
  }

  Future<User?> getAuthData() async {
    String? userLogin;
    String? userPassword;

    // Récupération des données de l'utilisateur
    try {
      final prefs = await SharedPreferences.getInstance();
      userLogin = prefs.getString('user_login');
      userPassword = prefs.getString('user_password');
    } catch (e) {
      throw Exception('Erreur lors de la récupération des données');
    }

    // Connecte l'utilisateur si les données sont présentes
    if (userLogin == null || userPassword == null) return null;
    User user = await authHandler.handleSignInEmail(userLogin, userPassword);
    appState.login(user);
    appState.updateCartCount();

    return user;
  }
}

class TopBar extends StatelessWidget {
  TopBar({Key? key}) : super(key: key);

  final AppState appState = GetIt.instance.get<AppState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40, bottom: 20, left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            splashRadius: 25,
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Profil(),
                ),
              )
            },
            icon: const Icon(
              Icons.account_circle,
              size: 30,
            ),
          ),
          const Logo(small: true),
          BasketButton(),
        ],
      ),
    );
  }
}

class BasketButton extends StatelessWidget {
  BasketButton({Key? key}) : super(key: key);

  final AppState appState = GetIt.instance.get<AppState>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: appState.streamBasketCounter,
        builder: (context, AsyncSnapshot<int> snapshot) {
          int cartCount = snapshot.data ?? 0;
          return IconButton(
              onPressed: () {
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) {
                      return const Basket();
                    });
              },
              splashRadius: 25,
              icon: cartCount > 0
                  ? Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.shopping_cart),
                        Positioned(
                            top: -10,
                            right: -10,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(cartCount.toString(),
                                  style: const TextStyle(color: Colors.white)),
                              padding: const EdgeInsets.only(
                                  top: 2, right: 6, left: 6, bottom: 2),
                            ))
                      ],
                    )
                  : const Icon(Icons.shopping_cart));
        });
  }
}

class ArticlesTabs extends StatefulWidget {
  final List tabs;

  const ArticlesTabs(this.tabs, {Key? key}) : super(key: key);

  @override
  _ArticlesTabsState createState() => _ArticlesTabsState();
}

class _ArticlesTabsState extends State<ArticlesTabs> {
  int _selectedIndex = 0;
  TabController? _tabController;

  @override
  void dispose() {
    super.dispose();
    _tabController?.animation?.removeListener(tabChangedListener);
  }

  void tabChangedListener() {
    if (DefaultTabController.of(context)?.animation!.value !=
        DefaultTabController.of(context)?.index) {
      setState(() {
        _selectedIndex =
            DefaultTabController.of(context)?.animation!.value.round() ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_tabController == null) {
      _tabController = DefaultTabController.of(context)!;
      _tabController?.animation?.addListener(tabChangedListener);
    }

    return Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: TabBar(
          indicatorSize: TabBarIndicatorSize.label,
          padding: const EdgeInsets.only(bottom: 10),
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Theme.of(context).colorScheme.primary,
          ),
          tabs: widget.tabs.map((item) {
            return Tab(
              height: 35,
              child: Center(
                child: Text(item['label'],
                    style: TextStyle(
                        color: item['id'] == _selectedIndex
                            ? Colors.white
                            : Colors.black)),
              ),
            );
          }).toList(),
        ));
  }
}

class ListItems extends StatefulWidget {
  const ListItems({Key? key}) : super(key: key);

  @override
  _ListItemsState createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> with TickerProviderStateMixin {
  AppState appState = GetIt.instance.get<AppState>();

  @override
  void initState() {
    super.initState();
    appState.reloadClothesList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: appState.clothesStream,
      builder: (context, AsyncSnapshot<List<List<Clothe>>> snapshot) {
        List<List<Clothe>> data = snapshot.data ?? [];
        if (data.isEmpty || data[0].isEmpty) {
          return const Expanded(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        } else {
          return Expanded(
              child: SizedBox(
                  width: double.infinity,
                  child: TabBarView(
                    children: [
                      page(data[0]),
                      page(data[1]),
                      page(data[2]),
                    ],
                  )));
        }
      },
    );
  }

  Widget page(List<Clothe> clothes) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(20),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        direction: Axis.horizontal,
        runSpacing: 10,
        children: clothes
            .map((item) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(children: [
                              ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  child: SizedBox(
                                      width: double.infinity,
                                      height:
                                          (MediaQuery.of(context).size.width) -
                                              130,
                                      child: (RegExp(r'^base64.*')
                                              .hasMatch(item.images[0]))
                                          ? Image.memory(
                                              base64Decode(item.images[0]
                                                  .substring(6,
                                                      item.images[0].length)),
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              item.images[0],
                                              fit: BoxFit.cover,
                                            ))),
                              Positioned.fill(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      AnimationController _animationController =
                                          BottomSheet.createAnimationController(
                                              this);
                                      showModalBottomSheet(
                                          transitionAnimationController:
                                              _animationController,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (context) {
                                            return Detail(
                                                clothe: item,
                                                controller:
                                                    _animationController);
                                          });
                                    },
                                    customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                    child: Column(
                                  children: [
                                    SizedBox(
                                        width: double.infinity,
                                        child: Text(item.title,
                                            style:
                                                const TextStyle(fontSize: 20))),
                                    SizedBox(
                                        width: double.infinity,
                                        child: Text('Taille: ${item.size}')),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                        width: double.infinity,
                                        child: Text('${item.price} €',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold))),
                                  ],
                                )),
                                FutureBuilder(
                                    future: appState.checkIfInBasket(item),
                                    builder: (context,
                                        AsyncSnapshot<bool?> snapshot) {
                                      bool inBasket = snapshot.data ?? false;
                                      if (snapshot.hasData) {
                                        return Container(
                                            decoration: BoxDecoration(
                                              color: inBasket
                                                  ? Colors.grey
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                            child: IconButton(
                                                onPressed: () =>
                                                    {if (!inBasket) buy(item)},
                                                color: Colors.white,
                                                splashColor: Colors.white,
                                                highlightColor: Colors.white,
                                                icon: const Icon(
                                                    Icons.add_shopping_cart)));
                                      } else {
                                        return Container();
                                      }
                                    }),
                              ],
                            ),
                          ])),
                ))
            .toList(),
      ),
    ));
  }

  void buy(Clothe clothe) async {
    var userUID = appState.user?.uid ?? '';

    try {
      await FirebaseFirestore.instance
          .collection('paniers')
          .doc(userUID)
          .update({
        'items': FieldValue.arrayUnion([clothe.id])
      });
      appState.updateCartCount();
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${clothe.title} ajouté au panier'),
          duration: const Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          duration: const Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
