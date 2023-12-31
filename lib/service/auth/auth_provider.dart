import 'auth_user.dart';

//this holds the providers for authentication we may need in future
abstract class AuthProvider {
  //we are meant to initilize the app here
  Future<void> iniitialize();
  //so any auth_provider should have the option to do these
  AuthUser? get currentUser;
  //login a user which should hve email and password or any other way of verification
Future<AuthUser> login({
    //for now, email and password
    required String email,
    required String password
}); 
//function to createuser
Future<AuthUser> createUser({
    //for now, email and password, more can be added depending on the auth rpovider
    required String email,
    required String password
}); 
//to logout
Future<void> logout();
//send verification
Future<void> sendEmailVerification();
}