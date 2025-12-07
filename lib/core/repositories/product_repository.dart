import 'dart:convert';
import 'package:flutter/services.dart';
import'../models/product.dart';

//A Repository is responsible for data access.
class ProductRepository {
  Future<List<Product>> fetchProducts() async{
    final jsonStr=await rootBundle.loadString('assets/mock_data/products.json');  //rootBundle is a global object that lets you read files packaged with your app (assets).Reads the entire file as a String.
    final list=json.decode(jsonStr) as List<dynamic>; //Converts the JSON string into Dart objects.

    return list.map((e)=>Product.fromJson(e as Map<String, dynamic>)).toList();//Convert each map to a Product object
  }
}