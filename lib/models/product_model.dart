class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String image; // Path in assets

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
  });
}
