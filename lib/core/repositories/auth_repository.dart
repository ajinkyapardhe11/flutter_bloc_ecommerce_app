import '../models/user.dart';
import'package:hive_flutter/hive_flutter.dart';

class AuthRepository {
  final Box _box = Hive.box('authBox');

  Future <User?> loadUser()async{ //User here is nullable because if no user is saved yet, you return null
    final raw =_box.get('user');
    if(raw==null) return null;
    return User.fromJson(Map<String,dynamic>.from(raw));

  }
  Future<void> saveUser(User user) async{
    await _box.put('user',user.toJson());
  }
  Future<void> clear()async{
    await _box.delete('user');
  }
}