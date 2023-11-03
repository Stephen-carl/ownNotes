
//an exception to be thrown if the databse is open already
class DatabaseAlreadyOpenException implements Exception {}
//just in case we cant get the path
class UnableToGetDocumenstDirectory implements Exception {}
//to stop someone for closing a DB that is not open
class DatabaseIsNotOpen implements Exception {}
//if i cant delete a user
class CouldNotDeleteUser implements Exception {}
//to delete notes 
class CouldNotDeleteNotes implements Exception{}
//if user already exist
class UserAlreadyExist implements Exception {}
//if the user does not exist and cant find it
class CouldNotFindUser implements Exception {}
//if the note cant be found based on the id
class CouldNotFindNote implements Exception {}
//if it did not update
class CouldNotUpdateNote implements Exception {}