import 'package:flutter/material.dart';
import '../models/product_model.dart';

class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  /// Add product to cart or increase quantity if it already exists
  void addToCart(Product product) {
    final index = _items.indexWhere((i) => i.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  /// Remove product completely from the cart
  void removeFromCart(String productId) {
    _items.removeWhere((i) => i.product.id == productId);
    notifyListeners();
  }

  /// Change quantity directly (used for any custom controls)
  void changeQuantity(String productId, int qty) {
    final index = _items.indexWhere((i) => i.product.id == productId);
    if (index >= 0) {
      if (qty <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = qty;
      }
      notifyListeners();
    }
  }

  /// ✅ Increase product quantity by 1
  void increaseQuantity(String productId) {
    final index = _items.indexWhere((i) => i.product.id == productId);
    if (index != -1) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  /// ✅ Decrease product quantity by 1 (remove if reaches 0)
  void decreaseQuantity(String productId) {
    final index = _items.indexWhere((i) => i.product.id == productId);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  /// Calculate total cart price
  double get totalPrice =>
      _items.fold(0, (sum, i) => sum + i.product.price * i.quantity);

  /// ✅ NEW: Get total number of items (sum of all quantities)
  int get totalItemsCount =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  /// Clear all items from the cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
