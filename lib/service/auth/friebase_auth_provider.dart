import 'auth_user.dart';
import 'auth_provider.dart';
import 'auth_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseAuthException;

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email, 
    required String password,
    }) async {
    //create a user with firebase
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );
      //check if the current user is there, retun the current user
      final users = currentUser;
      if (users != null) {
        //then it true that, that is a correct current user
        return users;
      } else {
        //throw an exception
        throw UserNotLoggedIn();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
      //throw our own error exceptions we created
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUse();                              
      } else if (e.code == 'invalid-email') {
        throw InvlaidEmailAuthException();         
      } else {
        //any exception not captured
        throw GenericAuthException();           
      }
    } //and any other exception we don't know about
    catch(_) {
      //any exception that is not firebase exception
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user =FirebaseAuth.instance.currentUser;
    if (user != null) {
      //get the user
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> login({
    required String email, 
    required String password,
    }) async {
    try {
      //try to login
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, 
        password: password
        );
      //get the user
      //remember that the current user is from the function current user
      final user = currentUser;
      //return user if not null
      if (user != null) {
        //then it true that, that is a correct current user
        return user;
      } else {
        //throw an exception
        throw UserNotLoggedIn();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-login-credentials') {
        throw InvalidLoginCredentials();
      } else if(e.code == 'invalid-email'){
        throw InvalidEmail();
      } else {
        throw GenericAuthException();
      }
    } //any other exception
    catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logout() async{
    //first the user should exist
    final user = FirebaseAuth.instance.currentUser;
    //then signout
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedIn();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    //to help send the user an email, y fire=st getting the user
    final user =  FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else{
      //throw the exception
      throw UserNotLoggedIn();
    }
  }
  
}