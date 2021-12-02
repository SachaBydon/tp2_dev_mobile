class Clothe {
  String id;
  String title;
  double price;
  String image;
  String size;
  String brand;
  int category;
  Clothe(this.id, this.title, this.price, this.image, this.size, this.brand,
      this.category);

  @override
  String toString() {
    var formatedImage =
        image.length > 10 ? image.substring(0, 10) + '...' : image;
    return 'Clothe{title: $title, price: $price, image: $formatedImage, size: $size, brand: $brand}';
  }

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    return other is Clothe && other.id == id;
  }
}
