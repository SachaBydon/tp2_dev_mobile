import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:tp2_dev_mobile/models/clothe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const colorGreen = Color(0xff26AE60);
const colorGreenLight = Color(0xff94D5B0);

class NewHome extends StatefulWidget {
  const NewHome({Key? key}) : super(key: key);

  @override
  _NewHomeState createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {
  int active = 0;
  List tabs = [
    {'id': 0, 'label': 'Tous'},
    {'id': 1, 'label': 'Vêtements'},
    {'id': 2, 'label': 'Accessoires'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          const TopBar(),
          ArticlesTabs(active, (val) => setActive(val), tabs),
          ListItems(active)
        ],
      ),
    );
  }

  setActive(int val) {
    setState(() {
      active = val;
    });
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
          InkWell(
            onTap: () => {},
            highlightColor: colorGreenLight,
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
            onPressed: () {},
            splashColor: colorGreen,
            highlightColor: colorGreenLight,
            splashRadius: 25,
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

class ArticlesTabs extends StatefulWidget {
  int active;
  Function(int) setActive;
  List tabs;

  ArticlesTabs(this.active, this.setActive, this.tabs, {Key? key})
      : super(key: key);

  @override
  _ArticlesTabsState createState() => _ArticlesTabsState();
}

class _ArticlesTabsState extends State<ArticlesTabs> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: widget.tabs.map((item) {
              return InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  splashColor: colorGreen,
                  highlightColor: colorGreenLight,
                  onTap: () {
                    widget.setActive(item['id']);
                  },
                  child: Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: (item['id'] == widget.active)
                            ? colorGreenLight
                            : null,
                      ),
                      child: Center(
                          child: Text(item['label'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500)))));
            }).toList()));
  }
}

class ListItems extends StatefulWidget {
  int active;
  ListItems(this.active, {Key? key}) : super(key: key);

  @override
  _ListItemsState createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SizedBox(
            width: double.infinity,
            child: FutureBuilder(
                future: getAllItems(widget.active),
                builder: (context, AsyncSnapshot<List<Clothe>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: colorGreen,
                      ),
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
                                    width: (MediaQuery.of(context).size.width /
                                            2) -
                                        30,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.black26, width: .5),
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
                                                          const BorderRadius
                                                                  .only(
                                                              topLeft:
                                                                  Radius
                                                                      .circular(
                                                                          10),
                                                              topRight: Radius
                                                                  .circular(
                                                                      10)),
                                                      child: SizedBox(
                                                          width: (MediaQuery
                                                                          .of(
                                                                              context)
                                                                      .size
                                                                      .width /
                                                                  2) -
                                                              30,
                                                          height: (MediaQuery.of(
                                                                          context)
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(item.title,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      20)),
                                                      Text(
                                                          'Taille: ${item.size}'),
                                                    ],
                                                  )),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text('${item.price}€',
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ]),
                                        Positioned.fill(
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {},
                                              customBorder:
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              splashColor:
                                                  colorGreen.withAlpha(70),
                                              highlightColor:
                                                  colorGreen.withAlpha(70),
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
                })));
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
