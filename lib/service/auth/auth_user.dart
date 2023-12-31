import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  //to know if email is verified, this is becuase we are doing that mostly in our login or register
  final bool isEmailVerified;
  //to get the current email of the user
  final String? email;

  //a constructor
  //and make emailverification required
  const AuthUser({ 
    required this.email, 
    required this.isEmailVerified});

  //factory constructor
  //so from the firebase user, we create the emailVerified value for this class 
  //so tthis is to ask if the email is verified, true or fasle
  factory AuthUser.fromFirebase(User user) => 
  AuthUser(
    isEmailVerified: user.emailVerified, 
    email: user.email);
}