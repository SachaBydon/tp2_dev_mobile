import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import 'package:tp2_dev_mobile/models/app_state.dart';
import 'package:tp2_dev_mobile/models/clothe.dart';

import 'package:tp2_dev_mobile/utils.dart';
import 'package:tp2_dev_mobile/widgets/image_square.dart';
import 'package:tp2_dev_mobile/widgets/topbar.dart';

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
  // Données pour le formulaire
  final Clothe _clothe = Clothe('', '', 0, [], '', '', 0);
  int? _category = 0;
  final _formKey = GlobalKey<FormState>();

  final AppState appState = GetIt.instance.get<AppState>();

  void submitForm() {
    FocusScope.of(context).unfocus();

    // Vérifie que les champs sont remplis
    if (_formKey.currentState!.validate()) {
      if (_clothe.images.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Veuillez choisir des images !'),
          duration: Duration(milliseconds: 2500),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ));
        return;
      }
      _clothe.category = _category ?? 0;

      // Ajoute le produit dans la base de données
      FirebaseFirestore.instance.collection('clothes').add({
        'titre': _clothe.title,
        'taille': _clothe.size,
        'prix': _clothe.price,
        'marque': _clothe.brand,
        'images': _clothe.images,
        'category': _clothe.category,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${_clothe.title} ajouté !'),
          duration: const Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
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
                decoration: textFormFieldDecoration('Nom', context),
                validator: (value) {
                  if (value == '') {
                    return 'Veuillez entrer un nom';
                  }
                  setState(() {
                    _clothe.title = value ?? '';
                  });
                },
              ),
              TextFormField(
                decoration: textFormFieldDecoration('Marque', context),
                validator: (value) {
                  if (value == '') {
                    return 'Veuillez entrer une marque';
                  }
                  setState(() {
                    _clothe.brand = value ?? '';
                  });
                },
              ),
              TextFormField(
                decoration: textFormFieldDecoration('Taille', context),
                validator: (value) {
                  if (value == '') {
                    return 'Veuillez entrer une taille';
                  }
                  setState(() {
                    _clothe.size = value ?? '';
                  });
                },
              ),
              TextFormField(
                decoration: textFormFieldDecoration('Prix', context),
                keyboardType: TextInputType.number,
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
              const Text('Catégorie:', style: TextStyle(fontSize: 16)),
              CategoryGroupRadio(onChanged: (int? value) {
                setState(() {
                  _category = value;
                });
              }),
              ImagePickerButton(onChanged: (List<String> value) {
                setState(() {
                  _clothe.images = value;
                });
              }),
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

// ignore: must_be_immutable
class CategoryGroupRadio extends StatefulWidget {
  Function(int? value) onChanged;
  CategoryGroupRadio({Key? key, required this.onChanged}) : super(key: key);

  @override
  _CategoryGroupRadioState createState() => _CategoryGroupRadioState();
}

class _CategoryGroupRadioState extends State<CategoryGroupRadio> {
  final List<String> _categories = ['Aucune', 'Vêtement', 'Accessoire'];
  int _activeCategory = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 55,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: _categories.map((String category) {
            int index = _categories.indexOf(category);
            bool isActive = index == _activeCategory;
            return Expanded(
                child: SizedBox(
              child: ElevatedButton(
                onPressed: () => changed(index),
                child: Text(category,
                    style: TextStyle(
                        fontSize: 15,
                        color: isActive ? Colors.white : Colors.grey.shade800)),
                style: ElevatedButton.styleFrom(
                    primary: isActive
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade300,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    )),
              ),
              height: double.infinity,
            ));
          }).toList(),
        ));
  }

  changed(int category) {
    setState(() {
      _activeCategory = category;
    });
    widget.onChanged(category);
  }
}

// ignore: must_be_immutable
class ImagePickerButton extends StatefulWidget {
  Function(List<String> value) onChanged;
  ImagePickerButton({Key? key, required this.onChanged}) : super(key: key);

  @override
  _ImagePickerButtonState createState() => _ImagePickerButtonState();
}

class _ImagePickerButtonState extends State<ImagePickerButton> {
  // ignore: prefer_typing_uninitialized_variables
  var _images = <String>[];

  _getFromGallery() async {
    // Récupération de l'image
    List<XFile>? pickedFile = await ImagePicker().pickMultiImage();

    // .pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images = [];
        for (XFile file in pickedFile) {
          _images.add(file.path);
        }
      });
    }

    List<String> imagesBase64 = <String>[];
    for (var image in _images) {
      // Conversion des images en base64
      List<int> imageBytes = await File(image).readAsBytes();
      String base64Image = base64Encode(imageBytes);
      imagesBase64.add('base64$base64Image');
    }
    widget.onChanged(imagesBase64);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        clipBehavior: Clip.hardEdge,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      minimumSize: const Size(double.infinity, 100),
                      padding: const EdgeInsets.only(bottom: 18, top: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed: () => _getFromGallery(),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.photo_library),
                          SizedBox(width: 10),
                          Text('Choisir des images',
                              style: TextStyle(fontSize: 16)),
                        ]))),
            _images.isNotEmpty ? ImageSquare(images: _images) : Container()
          ],
        ));
  }
}
