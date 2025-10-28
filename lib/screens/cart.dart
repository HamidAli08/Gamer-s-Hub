import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String address = '';
  bool isAddressEntered = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: cart.items.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];

                      // ✅ Handle network or asset image
                      Widget imageWidget;
                      if (item.product.image.startsWith('http')) {
                        imageWidget = Image.network(
                          item.product.image,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, color: Colors.grey),
                        );
                      } else {
                        imageWidget = Image.asset(
                          item.product.image,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported, color: Colors.grey),
                        );
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: imageWidget,
                          title: Text(item.product.name),
                          subtitle: Text('Rs: ${item.product.price} x ${item.quantity}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () =>
                                    cart.decreaseQuantity(item.product.id),
                              ),
                              Text('${item.quantity}',
                                  style: const TextStyle(fontSize: 16)),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () =>
                                    cart.increaseQuantity(item.product.id),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Color.fromARGB(255, 80, 0, 172)),
                                onPressed: () =>
                                    cart.removeFromCart(item.product.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ✅ Total price section
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Total: Rs: ${cart.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),

                // ✅ Address input field
                if (isAddressEntered == true || address.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          address = value;
                          isAddressEntered = address.isNotEmpty;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Enter your delivery address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                const SizedBox(height: 10),

                // ✅ Buttons (Buy Now and Checkout)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.location_on),
                        label: const Text('Buy Now'),
                        onPressed: () {
                          setState(() {
                            isAddressEntered = true;
                          });
                        },
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.payment),
                        label: const Text('Checkout'),
                        onPressed: address.isNotEmpty
                            ? () {
                                // ✅ Navigate to payment screen
                                Navigator.pushNamed(
                                  context,
                                  '/payment',
                                  arguments: {
                                    'totalPrice': cart.totalPrice,
                                    'address': address,
                                  },
                                );
                              }
                            : null, // Disabled if no address entered
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
