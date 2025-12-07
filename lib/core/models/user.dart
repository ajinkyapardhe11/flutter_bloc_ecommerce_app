class User {
  final String id;
  final String email;
  final bool isGuest;

  User({
    required this.id,
    required this.email,
    this.isGuest=false,
  });

  Map<String,dynamic> toJson(){
    return{
      'id':id,
      'email':email,
      'isGuest':isGuest
    };
  }
  factory User.fromJson(Map<String,dynamic> json){
    return User(
      email: json['email'],
      id:json['id'],
      isGuest:json['isGuest']??false
    );
  }
  factory User.guest(){
    return User(
      id: 'guest',
      email: 'user@example.com',
      isGuest: true
    );
  }

}