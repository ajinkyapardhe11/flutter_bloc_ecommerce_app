import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/cart_state.dart';
import '../bloc/cart_event.dart';
import 'checkout_page.dart';
import '../../../widgets/quantity_selector.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CartEmpty) {
            return const Center(child: Text('Cart is empty'));
          }
          if (state is CartLoadSuccess) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (_, i) {
                      final it = state.items[i];
                      return ListTile(
                        leading: Image.network(
                          it.imageUrl,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                        title: Text(it.title),
                        subtitle: Text(
                            '₹${it.price.toStringAsFixed(2)} × ${it.qty}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            QuantitySelector(
                              value: it.qty,
                              onChanged: (val) {
                                context.read<CartBloc>().add(
                                      UpdateQuantity(it.productId, val),
                                    );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                context
                                    .read<CartBloc>()
                                    .add(RemoveItem(it.productId));
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                          'Subtotal: ₹${state.subtotal.toStringAsFixed(2)}'),
                      Text('Tax (5%): ₹${state.tax.toStringAsFixed(2)}'),
                      Text(
                        'Total: ₹${state.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              context.read<CartBloc>().add(ClearCart());
                            },
                            child: const Text('Clear Cart'),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CheckoutPage(),
                                ),
                              );
                            },
                            child: const Text('Checkout'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
