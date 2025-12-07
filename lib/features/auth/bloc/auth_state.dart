
import 'package:equatable/equatable.dart';
import'../../../core/models/user.dart';

abstract class AuthState extends Equatable{  //All possible UI conditions related to auth
  @override
  List<Object?>get props=>[];

}

class AuthInitial extends AuthState{}

class AuthLoading extends AuthState{}

class AuthAuthenticated extends AuthState{
  final User user;
  AuthAuthenticated(this.user);
  @override 
  List <Object?> get props=>[user]; //Helps detect if user changed.
}

class AuthUnauthenticated extends AuthState{}

class AuthFailer extends AuthState{
  final String message;
  AuthFailer(this.message);
  @override
  List<Object?> get props=>[message];
}