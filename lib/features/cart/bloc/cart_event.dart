import 'package:equatable/equatable.dart';
import '../../../core/models/cart_items.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {}

class AddItem extends CartEvent {
  final CartItems item;
  AddItem(this.item);
  @override
  List<Object?> get props => [item];
}

class RemoveItem extends CartEvent {
  final String productId;
  RemoveItem(this.productId);
  @override
  List<Object?> get props => [productId];
}

class UpdateQuantity extends CartEvent {
  final String productId;
  final int qty;
  UpdateQuantity(this.productId, this.qty);
  @override
  List<Object?> get props => [productId, qty];
}

class ClearCart extends CartEvent {}
