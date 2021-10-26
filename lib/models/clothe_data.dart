import 'package:tp2_dev_mobile/models/clothe.dart';

class ClotheData {
  List<Clothe> clothes = [];
  List<Clothe> basket = [];
  double totalPrice = 0;
  int totalQuantity = 0;

  isInBasket(Clothe clothe) {
    return basket.contains(clothe);
  }

  addAll(List<Clothe> clothesToAdd) {
    for (Clothe clothe in clothesToAdd) {
      if (!clothes.contains(clothe)) {
        clothes.add(clothe);
      }
    }
  }

  addAllToBasket(List<String> clothesToAdd) {
    for (String clotheId in clothesToAdd) {
      Clothe clothe = clothes.firstWhere((clothe) => clothe.id == clotheId);
      if (!basket.contains(clothe)) {
        basket.add(clothe);
        totalPrice += clothe.price;
      }
    }
    totalQuantity = basket.length;
  }

  addToBasket(Clothe clothe) {
    if (!basket.contains(clothe)) {
      basket.add(clothe);
      totalPrice += clothe.price;
      totalQuantity = basket.length;
    }
  }

  removeFromBasket(Clothe clothe) {}
}
