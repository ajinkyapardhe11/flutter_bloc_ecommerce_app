import 'package:equatable/equatable.dart';
import '../../../core/models/cart_items.dart';

abstract class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartLoadInProgress extends CartState {}

class CartEmpty extends CartState {}

class CartLoadSuccess extends CartState {
  final List<CartItems> items;
  final double subtotal;
  final double tax;
  final double total;

  CartLoadSuccess({
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
  });

  @override
  List<Object?> get props => [items, subtotal, tax, total];
}

class CartFailure extends CartState {
  final String error;
  CartFailure(this.error);
  @override
  List<Object?> get props => [error];
}
