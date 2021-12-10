class Clothe {
  String id;
  String title;
  num price;
  List<String> images;
  String size;
  String brand;
  int category;
  Clothe(this.id, this.title, this.price, this.images, this.size, this.brand,
      this.category);

  @override
  String toString() {
    return 'Clothe{title: $title, price: $price, size: $size, brand: $brand}';
  }
}
