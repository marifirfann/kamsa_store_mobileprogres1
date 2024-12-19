class Product {
  String id;
  String title;
  String description;
  String price;
  String stock;
  String image;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.stock,
    required this.image,
  });

  // Convert Firestore data to Product object
  factory Product.fromFirestore(Map<String, dynamic> firestoreData, String id) {
    return Product(
      id: id,
      title: firestoreData['title'] ?? '',
      description: firestoreData['description'] ?? '',
      price: firestoreData['price'] ?? '',
      stock: firestoreData['stock'] ?? '',
      image: firestoreData['image'] ?? '',
    );
  }

  // Convert Product object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'stock': stock,
      'image': image,
    };
  }
}
