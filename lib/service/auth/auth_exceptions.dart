//so here e define our auth exceptions that we may encoutner login and register
//so this is like saying, here is a my own class that represents an exception
class UserNotfoundAuthException implements Exception{
  
}

//login
class InvalidEmail implements Exception{
  
}

class InvalidLoginCredentials implements Exception{
  
}

//register exceptions
class WeakPasswordAuthException implements Exception {
  
}

class EmailAlreadyInUse implements Exception {
  
}

class InvlaidEmailAuthException implements Exception {
  
}

//unknown firebase exceptions


//generic or other exception
class GenericAuthException implements Exception {
  
}

//also for logging out
class UserNotLoggedIn implements Exception { //if the user is null
  
}

