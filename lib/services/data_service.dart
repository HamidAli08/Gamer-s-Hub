import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class DataService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<Product>> loadProducts() async {
    try {
      final snapshot = await _firestore.collection('products').get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Product(
          id: doc.id, // ✅ Fix here
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          price: (data['price'] ?? 0).toDouble(),
          category: data['category'] ?? '',
          image: data['image'] ?? '',
        );
      }).toList();
    } catch (e) {
      print('Error loading products: $e');
      return [];
    }
  }
}
