import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();

  String cardName = '';
  String cardNumber = '';
  String expiryDate = '';
  String cvv = '';

  bool showCardForm = false;
  bool isProcessing = false;

  Map<String, dynamic>? _readArgs(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null) return null;
    if (args is Map<String, dynamic>) return args;
    if (args is Map) return Map<String, dynamic>.from(args);
    return null;
  }

  Future<void> _processPayment({required bool isCard}) async {
    setState(() => isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => isProcessing = false);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isCard ? 'Payment Successful' : 'Order Placed'),
        content: Text(isCard
            ? 'Your card payment has been processed successfully!'
            : 'Your order has been placed (Cash on Delivery).'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );

    // ✅ Clear cart after successful payment
    Provider.of<CartProvider>(context, listen: false).clearCart();

    Navigator.popUntil(context, ModalRoute.withName('/dashboard'));
  }

  // Formatter for card number (1234 5678 9012 3456)
  final _cardNumberFormatter = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(16),
    TextInputFormatter.withFunction((oldValue, newValue) {
      final text = newValue.text.replaceAll(' ', '');
      final newText = text.replaceAllMapped(RegExp(r'.{4}'), (match) => '${match.group(0)} ');
      return TextEditingValue(
        text: newText.trimRight(),
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }),
  ];

  // Formatter for expiry (MM/YY)
  final _expiryFormatter = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(4),
    TextInputFormatter.withFunction((oldValue, newValue) {
      var text = newValue.text;
      if (text.length >= 3) {
        text = '${text.substring(0, 2)}/${text.substring(2)}';
      }
      return TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }),
  ];

  @override
  Widget build(BuildContext context) {
    final args = _readArgs(context);
    final double totalPrice =
        (args != null && args['totalPrice'] is num) ? (args['totalPrice'] as num).toDouble() : 0.0;
    final String address = (args != null && args['address'] is String)
        ? args['address'] as String
        : 'Not Provided';

    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isProcessing
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Order Summary',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('Delivery Address: $address'),
                    const SizedBox(height: 5),
                    Text('Total Amount: Rs ${totalPrice.toStringAsFixed(2)}',
                        style:
                            const TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 155, 68, 206))),
                    const Divider(height: 30),
                    const Text('Select Payment Method:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 15),

                    ElevatedButton.icon(
                      icon: const Icon(Icons.credit_card),
                      label: const Text('Pay via Card'),
                      onPressed: () {
                        setState(() {
                          showCardForm = true;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton.icon(
                      icon: const Icon(Icons.money),
                      label: const Text('Cash on Delivery'),
                      onPressed: () async {
                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Confirm Cash on Delivery'),
                            content: Text(
                                'Proceed with Cash on Delivery for Rs ${totalPrice.toStringAsFixed(2)}?\n\nDelivery Address:\n$address'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel')),
                              ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Confirm')),
                            ],
                          ),
                        );
                        if (ok == true) {
                          await _processPayment(isCard: false);
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    if (showCardForm)
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Cardholder Name',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                      ? 'Enter cardholder name'
                                      : null,
                              onChanged: (value) => cardName = value,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Card Number',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: _cardNumberFormatter,
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Enter card number';
                                final cleaned = value.replaceAll(' ', '');
                                if (cleaned.length < 16) return 'Enter valid card number';
                                return null;
                              },
                              onChanged: (value) => cardNumber = value,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Expiry (MM/YY)',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: _expiryFormatter,
                                    validator: (value) =>
                                        (value == null || value.isEmpty)
                                            ? 'Enter expiry'
                                            : null,
                                    onChanged: (value) => expiryDate = value,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'CVV',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    maxLength: 3,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return 'Enter CVV';
                                      if (value.length < 3) return 'Invalid CVV';
                                      return null;
                                    },
                                    onChanged: (value) => cvv = value,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState?.validate() != true) return;
                                await _processPayment(isCard: true);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 108, 42, 222)),
                              child: const Text('Confirm Card Payment'),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
