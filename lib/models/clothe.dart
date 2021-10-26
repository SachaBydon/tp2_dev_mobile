class Clothe {
  String id;
  String title;
  double price;
  String image;
  String size;
  String brand;
  Clothe(this.id, this.title, this.price, this.image, this.size, this.brand);

  @override
  String toString() {
    var formatedImage =
        image.length > 10 ? image.substring(0, 10) + '...' : image;
    return 'Clothe{title: $title, price: $price, image: $formatedImage, size: $size, brand: $brand}';
  }

  @override
  bool operator ==(other) {
    return other is Clothe && other.id == id;
  }
}
