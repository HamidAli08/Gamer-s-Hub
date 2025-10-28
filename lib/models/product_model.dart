class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String image; // Path in assets or Firestore URL

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
  });

  // ✅ Factory constructor for Firestore
  factory Product.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId, // ✅ Unique Firestore document ID
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      category: data['category'] ?? '',
      image: data['image'] ?? '',
    );
  }
}
