import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/product_tile.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_state.dart';
import '../bloc/product_event.dart';

enum ProductSortOption {
  nameAsc,
  priceLowHigh,
  priceHighLow,
}

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  ProductSortOption _selectedSort = ProductSortOption.nameAsc;

  String _sortLabel(ProductSortOption option) {
    switch (option) {
      case ProductSortOption.nameAsc:
        return 'Name (A–Z)';
      case ProductSortOption.priceLowHigh:
        return 'Price (Low → High)';
      case ProductSortOption.priceHighLow:
        return 'Price (High → Low)';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sneaker Store'),
        actions: [
          PopupMenuButton<ProductSortOption>(
            initialValue: _selectedSort,
            onSelected: (val) {
              setState(() {
                _selectedSort = val;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: ProductSortOption.nameAsc,
                child: Text(_sortLabel(ProductSortOption.nameAsc)),
              ),
              PopupMenuItem(
                value: ProductSortOption.priceLowHigh,
                child: Text(_sortLabel(ProductSortOption.priceLowHigh)),
              ),
              PopupMenuItem(
                value: ProductSortOption.priceHighLow,
                child: Text(_sortLabel(ProductSortOption.priceHighLow)),
              ),
            ],
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProductLoadSuccess) {
            // Make a copy so we don’t modify Bloc’s list
            final products = [...state.products];

            // Apply sorting based on selected option
            products.sort((a, b) {
              switch (_selectedSort) {
                case ProductSortOption.nameAsc:
                  return a.title.toLowerCase().compareTo(
                        b.title.toLowerCase(),
                      );
                case ProductSortOption.priceLowHigh:
                  return a.price.compareTo(b.price);
                case ProductSortOption.priceHighLow:
                  return b.price.compareTo(a.price);
              }
            });

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProductBloc>().add(RefreshProducts());
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount =
                      constraints.maxWidth > 600 ? 3 : 2;
                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 0.70,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: products.length,
                    itemBuilder: (_, i) =>
                        ProductTile(product: products[i]),
                  );
                },
              ),
            );
          }
          if (state is ProductLoadFailure) {
            return Center(child: Text('Error: ${state.error}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
