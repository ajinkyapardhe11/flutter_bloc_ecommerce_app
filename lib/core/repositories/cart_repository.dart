import 'package:hive_flutter/hive_flutter.dart';
import'../models/cart_items.dart';
class CartRepository {
  final Box _box=Hive.box('cartBox');//Gets reference to the box named "cartBox"

  Future <List<CartItems>> loadCart()async{
    final list=_box.get('cart') as List<dynamic>;

    if(list==null) return[];
    return list.map((e)=>CartItems.fromJson(Map<String,dynamic>.from(e))).toList();
  }
  Future<void> saveCart(List<CartItems> items)async{
    await _box.put('cart',items.map((e)=>e.toJson()).toList());
  }
  Future<void> clearCart()async{
    await _box.delete('cart');

  }
}