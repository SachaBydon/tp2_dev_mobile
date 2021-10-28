import 'package:flutter/material.dart';
import 'package:tp2_dev_mobile/models/app_state.dart';
import 'package:tp2_dev_mobile/models/clothe.dart';
import 'package:tp2_dev_mobile/screens/basket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

class NewProduct extends StatefulWidget {
  const NewProduct({Key? key}) : super(key: key);

  @override
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: const <Widget>[
          TopBar('Nouveau produit'),
          Expanded(child: SingleChildScrollView(child: FormProduct())),
        ]));
  }
}

class FormProduct extends StatefulWidget {
  const FormProduct({Key? key}) : super(key: key);

  @override
  _FormProductState createState() => _FormProductState();
}

class _FormProductState extends State<FormProduct> {
  Clothe _clothe = Clothe('', '', 0, '', '', '', 0);
  int? _category = 0;
  final _formKey = GlobalKey<FormState>();
  final AppState appState = GetIt.instance.get<AppState>();

  void submitForm() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _clothe.category = _category ?? 0;
      print(_clothe);

      FirebaseFirestore.instance.collection('clothes').add({
        'titre': _clothe.title,
        'taille': _clothe.size,
        'prix': _clothe.price,
        'marque': _clothe.brand,
        'image': _clothe.image,
        'category': _clothe.category,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${_clothe.title} ajouté !'),
          duration: const Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ));
        appState.reloadClothesList();
        Navigator.of(context).pop();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            duration: const Duration(milliseconds: 1500),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        child: Form(
            key: _formKey,
            child: Wrap(runSpacing: 10, children: [
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelText: 'Nom',
                ),
                validator: (value) {
                  if (value == '') {
                    return 'Veuillez entrer un nom';
                  }
                  setState(() {
                    print(value);
                    _clothe.title = value ?? '';
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelText: 'Marque',
                ),
                validator: (value) {
                  if (value == '') {
                    return 'Veuillez entrer une marque';
                  }
                  setState(() {
                    print(value);
                    _clothe.brand = value ?? '';
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelText: 'Taille',
                ),
                validator: (value) {
                  if (value == '') {
                    return 'Veuillez entrer une taille';
                  }
                  setState(() {
                    print(value);
                    _clothe.size = value ?? '';
                  });
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelText: 'Prix',
                ),
                validator: (value) {
                  if (value == '') {
                    return 'Veuillez entrer un prix';
                  }
                  setState(() {
                    value = value?.replaceAll(',', '.');
                    _clothe.price = double.parse(value ?? '');
                  });
                },
              ),
              TextFormField(
                initialValue:
                    'https://img-19.ccm2.net/cI8qqj-finfDcmx6jMK6Vr-krEw=/1500x/smart/b829396acc244fd484c5ddcdcb2b08f3/ccmcms-commentcamarche/20494859.jpg',
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelText: 'Image',
                ),
                validator: (value) {
                  if (value == '') {
                    return 'Veuillez entrer une image';
                  }
                  setState(() {
                    print(value);
                    _clothe.image = value ?? '';
                  });
                },
              ),
              const Text('Catégorie:', style: TextStyle(fontSize: 16)),
              Column(children: [
                Row(
                  children: [
                    Radio<int>(
                      activeColor: Theme.of(context).colorScheme.primary,
                      value: 0,
                      groupValue: _category,
                      onChanged: (int? value) {
                        setState(() {
                          _category = value;
                        });
                      },
                    ),
                    const Text('Aucune')
                  ],
                ),
                Row(
                  children: [
                    Radio<int>(
                      activeColor: Theme.of(context).colorScheme.primary,
                      value: 1,
                      groupValue: _category,
                      onChanged: (int? value) {
                        setState(() {
                          _category = value;
                        });
                      },
                    ),
                    const Text('Vêtement')
                  ],
                ),
                Row(
                  children: [
                    Radio<int>(
                      activeColor: Theme.of(context).colorScheme.primary,
                      value: 2,
                      groupValue: _category,
                      onChanged: (int? value) {
                        setState(() {
                          _category = value;
                        });
                      },
                    ),
                    const Text('Accessoire')
                  ],
                )
              ]),
              ElevatedButton(
                onPressed: () => submitForm(),
                child: Wrap(
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: const [
                    Icon(Icons.add),
                    Text(
                      'Ajouter',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.only(bottom: 18, top: 18),
                  minimumSize: const Size(double.infinity, 30),
                ),
              ),
            ])));
  }
}
