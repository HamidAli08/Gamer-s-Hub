import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String? userAddress; // stores address
  bool addressEntered = false;

  void _askForAddress(BuildContext context) {
    final TextEditingController addressController =
        TextEditingController(text: userAddress ?? "");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Enter Delivery Address'),
        content: TextField(
          controller: addressController,
          decoration: const InputDecoration(
            labelText: 'Complete Address',
            hintText: 'House #, Street #, City, etc.',
          ),
          maxLines: 2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (addressController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Address cannot be empty')),
                );
                return;
              }
              setState(() {
                userAddress = addressController.text.trim();
                addressEntered = true;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Address saved successfully!')),
              );
            },
            child: const Text('Save Address'),
          ),
        ],
      ),
    );
  }

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

                      Widget imageWidget;
                      if (item.product.image.startsWith('http')) {
                        imageWidget = Image.network(
                          item.product.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, color: Colors.grey),
                        );
                      } else {
                        imageWidget = Image.asset(
                          item.product.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported,
                                  color: Colors.grey),
                        );
                      }

                      return ListTile(
                        leading: imageWidget,
                        title: Text(item.product.name),
                        subtitle: Text(
                            'Rs: ${item.product.price} x ${item.quantity}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () =>
                              cart.removeFromCart(item.product.id),
                        ),
                      );
                    },
                  ),
                ),

                // Address info section
                if (addressEntered)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Delivery Address:\n$userAddress",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Total: Rs: ${cart.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Buy Now button (address input)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.location_on),
                      onPressed: () => _askForAddress(context),
                      label: const Text('Buy Now'),
                    ),

                    // Checkout button (go to payment)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.payment),
                      onPressed: addressEntered
                          ? () => Navigator.pushNamed(context, '/payment',
                              arguments: userAddress)
                          : null, // disabled if no address
                      label: const Text('Checkout'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
    );
  }
}
