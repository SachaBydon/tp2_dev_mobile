//Clothe class to store clothes data from firebase
class Clothe {
  String title;
  double price;
  String image;
  String size;
  String brand;
  Clothe(this.title, this.price, this.image, this.size, this.brand);

  @override
  String toString() {
    var formatedImage =
        image.length > 10 ? image.substring(0, 10) + '...' : image;
    return 'Clothe{title: $title, price: $price, image: $formatedImage, size: $size, brand: $brand}';
  }
}
