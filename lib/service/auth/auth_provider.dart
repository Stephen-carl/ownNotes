import 'auth_user.dart';

//this holds the providers for authentication we may need in future
abstract class AuthProvider {
  //so any auth_provider should habe the option to do these
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