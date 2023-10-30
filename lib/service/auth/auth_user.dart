import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  //to know if email is verified, this is becuase we are doing that mostly in our login or register
  final bool isEmailVerified;
  //a constructor
  const AuthUser(this.isEmailVerified);

  //factory constructor
  //so from the firebase user, we create the emailVerified value for this class 
  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
}