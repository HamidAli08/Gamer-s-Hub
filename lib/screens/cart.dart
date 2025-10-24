import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: cart.items.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return ListTile(
                        leading: Image.asset(item.product.image, width: 50),
                        title: Text(item.product.name),
                        subtitle: Text('Rs: ${item.product.price} x ${item.quantity}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => cart.removeFromCart(item.product.id),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Total: Rs: ${cart.totalPrice.toStringAsFixed(2)}'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to checkout or show dialog for COD form
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Checkout (COD)'),
                          content: const Text('Implement checkout form here'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))
                          ],
                        ),
                      );
                    },
                    child: const Text('Checkout (Cash on Delivery)'),
                  ),
                ),
              ],
            ),
    );
  }
}
