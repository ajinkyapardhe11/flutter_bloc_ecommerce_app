import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/cart_items.dart';
import '../../../core/repositories/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repo;
  final Map<String, CartItems> _items = {};

  CartBloc(this.repo) : super(CartLoadInProgress()) {
    on<LoadCart>(_onLoad);
    on<AddItem>(_onAdd);
    on<RemoveItem>(_onRemove);
    on<UpdateQuantity>(_onUpdate);
    on<ClearCart>(_onClear);
  }

  Future<void> _onLoad(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoadInProgress());
    final list = await repo.loadCart();
    _items.clear();
    for (final it in list) {
      _items[it.productId] = it;
    }
    _emitSuccess(emit);
  }

  Future<void> _onAdd(AddItem event, Emitter<CartState> emit) async {
    final item = event.item;
    if (_items.containsKey(item.productId)) {
      _items[item.productId]!.qty += item.qty;
    } else {
      _items[item.productId] = item;
    }
    await repo.saveCart(_items.values.toList());
    _emitSuccess(emit);
  }

  Future<void> _onRemove(RemoveItem event, Emitter<CartState> emit) async {
    _items.remove(event.productId);
    await repo.saveCart(_items.values.toList());
    _emitSuccess(emit);
  }

  Future<void> _onUpdate(
      UpdateQuantity event, Emitter<CartState> emit) async {
    if (_items.containsKey(event.productId)) {
      _items[event.productId]!.qty = event.qty;
    }
    await repo.saveCart(_items.values.toList());
    _emitSuccess(emit);
  }

  Future<void> _onClear(ClearCart event, Emitter<CartState> emit) async {
    _items.clear();
    await repo.clearCart();
    emit(CartEmpty());
  }

  void _emitSuccess(Emitter<CartState> emit) {
    final items = _items.values.toList();
    if (items.isEmpty) {
      emit(CartEmpty());
      return;
    }
    final subtotal =
        items.fold<double>(0, (sum, it) => sum + it.price * it.qty);
    final tax = subtotal * 0.05;
    final total = subtotal + tax;
    emit(CartLoadSuccess(
      items: items,
      subtotal: subtotal,
      tax: tax,
      total: total,
    ));
  }
}
