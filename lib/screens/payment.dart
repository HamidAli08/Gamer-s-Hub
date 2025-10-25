import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? selectedMethod;

  void confirmPayment() {
    if (selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }

    String message = selectedMethod == 'card'
        ? 'Your card payment was successful 🎉'
        : 'Your order has been placed successfully (Cash on Delivery) 🏠';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Payment Confirmation'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.popUntil(context, ModalRoute.withName('/dashboard'));
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Method')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose a payment option:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            RadioListTile<String>(
              title: const Text('Pay via Card 💳'),
              value: 'card',
              groupValue: selectedMethod,
              onChanged: (value) => setState(() => selectedMethod = value),
            ),
            RadioListTile<String>(
              title: const Text('Cash on Delivery 💵'),
              value: 'cod',
              groupValue: selectedMethod,
              onChanged: (value) => setState(() => selectedMethod = value),
            ),

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: confirmPayment,
                child: const Text('Confirm Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
