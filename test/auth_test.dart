import 'package:ownnotes/service/auth/auth_exceptions.dart';
import 'package:ownnotes/service/auth/auth_provider.dart';
import 'package:ownnotes/service/auth/auth_user.dart';
import 'package:test/test.dart';
//this is how main function in flutter looks like
void main() {
  //create a test group and a test ;
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    //create a test function, put its name and function
    test('Should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });

    //test for logging out  without initialization
    test('Cannot log out if not initiialized', () {
      //so we are saying execute the logout function
      expect(provider.logout(), 
      //test the result against a matcher
      throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    //test to initialize mock provider
    test('Should be able to be initialized', () async{
      await provider.iniitialize();
      expect(provider.isInitialized, true);
    });

    //testing null user upon initialization, cus its meant to be null until registration
    test('User should be null upon initialization', () {
      expect(provider.currentUser, null);
    });

    //test to see the time required for initialize, can help for API test
    test('should be able to initialize in less than 2 seconds', () async{
      await provider.iniitialize();
      expect(provider.isInitialized, true);
    }, 
    //so if it takes more than 2 seconds, it should kill the operation
      timeout: const Timeout(Duration(seconds: 2)),
    );

    //test to create a user
    test('Create user should delegate to login function', () async{
      //test bad password
      final badEmailUser = provider.createUser(
        email: 'foo@bar.com', 
        password: 'anypassword',
      );
        expect(badEmailUser, throwsA(const TypeMatcher<UserNotfoundAuthException>()));

        final badPasswordUser = provider.createUser(
          email: 'someone@bar.com', 
          password: 'foobar'
        );
          //throw wrong password
          expect(badPasswordUser, throwsA(const TypeMatcher<InvalidLoginCredentials>()));

          //to test for user
          final users = await provider.createUser(
            email: 'foo', 
            password: 'bar',
          );
          expect(provider.currentUser, users);
          expect(users.isEmailVerified, false);
    });
          //test emailVerification after registeration
    test('Logged in user should be able to get verified', () {
            provider.sendEmailVerification();
            final uses = provider.currentUser;
            expect(uses, isNotNull);
            expect(uses!.isEmailVerified, true);
    });
    //test logging out and in
    test('Should be able to log out and log in again', () async{
      await provider.logout();
      await provider.login(
        email: 'email', 
        password: 'password',
    );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

//the exception if it fails
class NotInitializedException implements Exception{}

class MockAuthProvider implements AuthProvider {
  //instance of Auth User
  AuthUser? _user;

  //check if the user is initialized
  var _isInitialized = false;
  //then initialize it
  bool get isInitialized => _isInitialized;


  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    //so if the mockauth is not initialized, throw that exception
    if(!isInitialized) throw NotInitializedException();
    //create a fake user, and since it will talk to firebase, we need a kind of delay
    await Future.delayed(const Duration(seconds: 1));
    //try to make the user login after the succesfully registratoin
    return login(
      email: email, 
      password: password,
    );
  }

  @override
  // return the current user
  AuthUser? get currentUser => _user;

  @override
  Future<void> iniitialize() async{
    // fke delay or waiting and bring the initialized flag to true
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> login({
    required String email, 
    required String password,
    }) async{
    //initialize firebase
      if(!isInitialized) throw NotInitializedException();
      if (email == 'foo@bar.com') throw UserNotfoundAuthException();
      if (password == 'foobar') throw InvalidLoginCredentials();
      //create a fake user
      const userr = AuthUser(isEmailVerified: false, email: 'foo@Bar.com');
      _user = userr;
      //return future of AuthUser
      return Future.value(userr); 
  }

  @override
  Future<void> logout() async {
    // initialize
    if(!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotfoundAuthException();
    //then delay the initialization
      await Future.delayed(const Duration(seconds: 1));
      _user = null;
  }

  @override
  Future<void> sendEmailVerification() async{
    // initialize
    if(!isInitialized) throw NotInitializedException();
    //get the user to make sure someone is logged in
    final userrr = _user;
    if (userrr == null) throw UserNotfoundAuthException();
    //then we get the new user
    const newUser = AuthUser(isEmailVerified: true, email: 'foo@Bar.com');
    _user = newUser;
  }
  
}