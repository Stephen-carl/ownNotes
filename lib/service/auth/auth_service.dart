import 'package:ownnotes/service/auth/friebase_auth_provider.dart';

import 'auth_provider.dart';
import 'auth_user.dart';


class AuthService implements AuthProvider {
  //instance of authProvider
  final AuthProvider provider;
  AuthService(this.provider);

  //firebase factory, where everything can be created to link up when needed
  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());
  
  //get the overrides
  @override
  Future<AuthUser> createUser({
    required String email, 
    required String password,
    }) => provider.createUser(
      email: email, 
      password: password
    );
  
  @override
  AuthUser? get currentUser => provider.currentUser;
  
  @override
  Future<AuthUser> login({
    required String email, 
    required String password,
    }) => provider.login(
      email: email, 
      password: password,
    );
  
  @override
  Future<void> logout() => provider.logout();
  
  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
  
  @override
  Future<void> iniitialize() => provider.iniitialize();
  }