// lib/features/cart/views/checkout_page.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/cart_state.dart';
import '../bloc/cart_event.dart';
import '../../../widgets/quantity_selector.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Shipping form controllers
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _pincodeCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _pincodeCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentStep == 0) {
      // just go to shipping
      setState(() => _currentStep = 1);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else if (_currentStep == 1) {
      // validate shipping form
      if (_formKey.currentState?.validate() ?? false) {
        setState(() => _currentStep = 2);
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      }
    }
  }

  void _back() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  Future<void> _placeOrder(CartLoadSuccess cartState) async {
    final id = 'ORD-2025-${Random().nextInt(9999).toString().padLeft(4, '0')}';

    context.read<CartBloc>().add(ClearCart());

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Order Placed'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your order ID is $id'),
            const SizedBox(height: 8),
            Text('Name: ${_nameCtrl.text}'),
            Text('Address: ${_addressCtrl.text}, ${_cityCtrl.text}'),
            Text('Pincode: ${_pincodeCtrl.text}'),
            Text('Phone: ${_phoneCtrl.text}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    Navigator.of(context).pop(); // go back from checkout
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CartEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }
          if (state is! CartLoadSuccess) {
            return const Center(child: Text('Error loading cart'));
          }

          final cartState = state;

          return Column(
            children: [
              // Step indicator
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StepCircle(label: 'Review', index: 0, current: _currentStep),
                    _StepCircle(label: 'Shipping', index: 1, current: _currentStep),
                    _StepCircle(label: 'Confirm', index: 2, current: _currentStep),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildReviewStep(cartState),
                    _buildShippingStep(),
                    _buildConfirmStep(cartState),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      TextButton(
                        onPressed: _back,
                        child: const Text('Back'),
                      ),
                    const Spacer(),
                    if (_currentStep < 2)
                      ElevatedButton(
                        onPressed: _next,
                        child: const Text('Next'),
                      )
                    else
                      ElevatedButton(
                        onPressed: () => _placeOrder(cartState),
                        child: const Text('Place Order'),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildReviewStep(CartLoadSuccess state) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text(
          'Review your cart',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...state.items.map(
          (it) => ListTile(
            leading: Image.network(it.imageUrl, width: 48, height: 48),
            title: Text(it.title),
            subtitle: Text('₹${it.price} × ${it.qty}'),
            trailing: Text('₹${(it.price * it.qty).toStringAsFixed(2)}'),
          ),
        ),
        const Divider(),
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Subtotal: ₹${state.subtotal.toStringAsFixed(2)}'),
              Text('Tax (5%): ₹${state.tax.toStringAsFixed(2)}'),
              Text(
                'Total: ₹${state.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShippingStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text(
              'Shipping address',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Full name'),
              validator: (val) =>
                  (val == null || val.isEmpty) ? 'Required' : null,
            ),
            TextFormField(
              controller: _addressCtrl,
              decoration: const InputDecoration(labelText: 'Address'),
              validator: (val) =>
                  (val == null || val.isEmpty) ? 'Required' : null,
              maxLines: 2,
            ),
            TextFormField(
              controller: _cityCtrl,
              decoration: const InputDecoration(labelText: 'City'),
              validator: (val) =>
                  (val == null || val.isEmpty) ? 'Required' : null,
            ),
            TextFormField(
              controller: _pincodeCtrl,
              decoration: const InputDecoration(labelText: 'Pincode'),
              keyboardType: TextInputType.number,
              validator: (val) {
                if (val == null || val.isEmpty) return 'Required';
                if (val.length < 4) return 'Too short';
                return null;
              },
            ),
            TextFormField(
              controller: _phoneCtrl,
              decoration: const InputDecoration(labelText: 'Phone number'),
              keyboardType: TextInputType.phone,
              validator: (val) {
                if (val == null || val.isEmpty) return 'Required';
                if (val.length < 8) return 'Too short';
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmStep(CartLoadSuccess state) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Confirm order',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ListTile(
          title: const Text('Shipping to'),
          subtitle: Text(
            '${_nameCtrl.text}\n${_addressCtrl.text}\n${_cityCtrl.text} - ${_pincodeCtrl.text}\nPhone: ${_phoneCtrl.text}',
          ),
        ),
        const Divider(),
        ListTile(
          title: const Text('Total amount'),
          trailing: Text(
            '₹${state.total.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Tap "Place Order" to complete your purchase.',
        ),
      ],
    );
  }
}

class _StepCircle extends StatelessWidget {
  final String label;
  final int index;
  final int current;

  const _StepCircle({
    required this.label,
    required this.index,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == current;
    return Column(
      children: [
        CircleAvatar(
          radius: isActive ? 14 : 12,
          backgroundColor: isActive ? Colors.blue : Colors.grey.shade400,
          child: Text(
            '${index + 1}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
