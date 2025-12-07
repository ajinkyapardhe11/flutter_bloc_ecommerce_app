class CartItems {
  final String productId;
  final String title;
  final double price;
  int qty;                 //qty is not final because it changes as we add the qunatity.other are final because they will not change per cart item
  final String imageUrl;

  CartItems({
    required this.productId,
    required this.title,
    required this.price,
    required this.qty,
    required this.imageUrl
  });
  factory CartItems.fromJson(Map<String,dynamic> json){
    return CartItems(
      productId: json['productId'],
      title: json['title'],
      price:(json['price'] as num).toDouble(),//JSON does NOT have Dart types. so here json['price'] is actually dynamic so we typecast it , as num converts to Dart’s common number type (int or double),and .toDouble() guarantees the final value is a double
      qty:json['qty'] as int,
      imageUrl: json['imageUrl']
    );
  }
  Map<String ,dynamic> toJson(){
    return{
      'productId':productId,
      'title':title,
      'price':price,
      'qty':qty,
      'imageUrl':imageUrl
    };
  }
}
