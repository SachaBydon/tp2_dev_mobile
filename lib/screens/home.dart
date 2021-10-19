import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:tp2_dev_mobile/models/clothe.dart';
import 'package:tp2_dev_mobile/screens/profil.dart';
import 'package:tp2_dev_mobile/screens/basket.dart';
import 'package:tp2_dev_mobile/screens/detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tp2_dev_mobile/models/auth.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: DefaultTabController(
          length: tabs.length,
          child: Column(
            children: <Widget>[const TopBar(), ArticlesTabs(tabs), ListItems()],
          ),
        ));
  }
}

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authContext = context.watch<AuthModel>();

    return FutureBuilder(
      future: getCartCount(authContext),
      builder: (context, AsyncSnapshot<int> snapshot) {
        int cartCount = snapshot.data ?? 0;
        return Container(
          padding:
              const EdgeInsets.only(top: 40, bottom: 20, left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profil(),
                    ),
                  )
                },
                child: const Padding(
                    padding: EdgeInsets.all(5),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('images/profile.png'),
                    )),
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Basket(),
                      ),
                    );
                  },
                  splashRadius: 25,
                  icon: cartCount > 0
                      ? Badge(
                          badgeColor: Theme.of(context).colorScheme.primary,
                          elevation: 0,
                          badgeContent: Text(cartCount.toString(),
                              style: TextStyle(color: Colors.white)),
                          child: const Icon(
                            Icons.shopping_cart,
                          ))
                      : const Icon(
                          Icons.shopping_cart,
                        )),
            ],
          ),
        );
      },
    );
  }

  Future<int> getCartCount(authContext) async {
    //TODO update on change
    String userUID = authContext.user?.uid ?? '';
    DocumentSnapshot<Map<String, dynamic>> basketQuery = await FirebaseFirestore
        .instance
        .collection('paniers')
        .doc(userUID)
        .get();

    return basketQuery['items'].length;
  }
}

class ArticlesTabs extends StatefulWidget {
  List tabs;

  ArticlesTabs(this.tabs, {Key? key}) : super(key: key);

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

    return TabBar(
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
    );
  }
}

class ListItems extends StatefulWidget {
  ListItems({Key? key}) : super(key: key);

  @override
  _ListItemsState createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SizedBox(
            width: double.infinity,
            child: TabBarView(
              // controller: widget.tabController,
              children: [
                page(0),
                page(1),
                page(2),
              ],
            )));
  }

  Widget page(id) {
    return FutureBuilder(
        future: getAllItems(id),
        builder: (context, AsyncSnapshot<List<Clothe>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                direction: Axis.horizontal,
                runSpacing: 10,
                children: snapshot.data
                        ?.map((item) => Container(
                            width: (MediaQuery.of(context).size.width / 2) - 30,
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.black26, width: .5),
                            ),
                            child: Stack(
                              children: <Widget>[
                                Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Center(
                                          child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(10),
                                                      topRight:
                                                          Radius.circular(10)),
                                              child: SizedBox(
                                                  width: (MediaQuery
                                                                  .of(context)
                                                              .size
                                                              .width /
                                                          2) -
                                                      30,
                                                  height:
                                                      (MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2) -
                                                          30,
                                                  child: Image.network(
                                                    item.image,
                                                    fit: BoxFit.cover,
                                                  )))),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                          height: 50,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(item.title,
                                                  style: const TextStyle(
                                                      fontSize: 20)),
                                              Text('Taille: ${item.size}'),
                                            ],
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text('${item.price}€',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ]),
                                Positioned.fill(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Detail(
                                              clothe: item,
                                            ),
                                          ),
                                        );
                                      },
                                      customBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )))
                        .toList() ??
                    [],
              ),
            ));
          }
        });
  }

  Future<List<Clothe>> getAllItems(category) async {
    QuerySnapshot? querySnapshot = null;
    var clothesCollection = FirebaseFirestore.instance.collection('clothes');
    if (category == 0) {
      querySnapshot = await clothesCollection.get();
    } else {
      querySnapshot =
          await clothesCollection.where('category', isEqualTo: category).get();
    }

    return querySnapshot.docs.map((doc) {
      return Clothe(doc.id, doc['titre'], doc['prix'], doc['image'],
          doc['taille'], doc['marque']);
    }).toList();
  }
}
