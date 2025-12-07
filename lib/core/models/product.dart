class Product{
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final double rating;
  final bool inStock;
  final String description;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.inStock,
    required this.description
  });
  factory Product.fromJson(Map<String,dynamic> json){
    return Product(
      id:json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'],
      rating: (json['rating'] as num).toDouble(),
      inStock: json['inStock'] as bool,
      description: json['description'],
    );
  }
  Map<String,dynamic> toJson(){
    return{
      'id':id,
      'title':title,
      'price':price,
      'imageUrl':imageUrl,
      'rating':rating,
      'inStock':inStock,
      'description':description
    };
  }
}