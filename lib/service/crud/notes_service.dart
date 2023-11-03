//create, delete, find,update users and notes
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

import 'crud_exceptions.dart';

//meant to be created outside the class
const idColumn = 'id';
const emailColumn = 'email';

//for notes the value of the clumn should eb the same as the one in database
const userIDColumn = 'user_id';
const textColumn = 'text';
const isSyncedColumn = 'is_synced_with_cloud';

//dbname and columns
const dbName = 'notes.db';
const usertable = 'user';
const noteTable = 'note';



//the main service of the database
class NotesService {
  Database? _db;
  
  //create a function to open the database
  Future<void> open() async {
    //store the database in the note
    //test to see if the db is open
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    //get the document directory path
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      //get the actual path/route of the database and join witht the path of the directory
      final dbPath = join(docsPath.path, dbName);
      //open the database, based on the path
      final db = await openDatabase(dbPath);
      //then assign the value to the local databse i can work with
      _db = db;

      //create user tables
      const createUserTable = ''' CREATE TABLE IF NOT EXISTS "user" (
	      "id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	      "email"	TEXT NOT NULL UNIQUE
        ); ''';
      //execute the query
      await db.execute(createUserTable);

      //create note table
      const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
          "id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          "userID"	INTEGER NOT NULL,
          "text"	TEXT,
          "is_synced_with_cloud"	INTEGER DEFAULT 0,
          FOREIGN KEY("userID") REFERENCES "user"("id")
        ); ''';
        //EXECUTE
        await db.execute(createNoteTable);
    } 
    //if it is unable to provide a system directory, throw an exception
    on MissingPlatformDirectoryException{
      throw UnableToGetDocumenstDirectory;
    }
  }

  //close the db
  Future<void> close() async{
    final dba = _db;
    //so if the db is null, meaing is not open and notihng is inside
    if (dba == null) {
      throw  DatabaseIsNotOpen();
    } else {
      //close db
      await dba.close();
      //reset db after closing
      _db = null;
    }
  }

  //function to always get the current currentDB instead of rewriting it
  Database _getDatabaseOrThrow() {
    //_db is the main Datase
    final db = _db;
    //this occurs after opening the db
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  //time to read and write to db
  //so we want to delete a user by their email address
  Future<void> deleteUser({required String email})async {
    //get current db using the function/method
    final dba = _getDatabaseOrThrow();
    //then delete column from the users table
    final deleteCount = await dba.delete(
      usertable, 
      where: ' email = ? ',
      whereArgs: [email.toLowerCase()],
    );
    //so incase i cannot delete user
    if (deleteCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  //allowing users to be created usig the databse user class
  Future<DatabaseUser> createUser({required String email}) async {
    //get the db
    final db = _getDatabaseOrThrow();
    //query the table to see if the user with that email already exist
    final results = await db.query(
      usertable,
      limit: 1,
      where: ' email = ? ',
      whereArgs: [email.toLowerCase()]
    );
    //after getting the result do the check
    if (results.isNotEmpty) {
      throw UserAlreadyExist();
    }

    //insert the email into the table
    //flutter has made it easy to insert id to iti
    final userID = await db.insert(
      usertable, 
      {emailColumn: email.toLowerCase()
    });
    //the main email will be insert in the UI
    //and the ID or the user will now be the userID gotten from here
    return DatabaseUser(id: userID, email: email);
  } 

  //ability to retirve user by the email
  Future<DatabaseUser> getUser({required String email}) async {
    //get the databzse
    final db = _getDatabaseOrThrow();
    //get the result of the query of the email
    final results = await db.query(
      usertable,
      limit: 1,
      where: ' email = ? ',
      whereArgs: [email.toLowerCase()]
    );
    //make sure the user exist or empty and should not be
    if (results.isEmpty) {
      //we didnt see user
      throw CouldNotFindUser();
    } else {
      //if there is a user by that email, return the result
      return DatabaseUser.fromRow(results.first);
    }
  }

  //create the notes and associate witht the database user
  Future<DatabaseNotes> createNotes({ required DatabaseUser owner }) async {
    //get ht current databse
    final db = _getDatabaseOrThrow();
    //chexk if theowner email is in the database
    final dbuser = await getUser(email: owner.email);
    if (dbuser != owner) {
      throw CouldNotFindUser();
    }

    const text = '';
    //create the notes by querying the database
    final noteId = await db.insert(
      //the values will be a map of the columns and its value
      noteTable, 
      {
        //so this owner.id is the one gotten when creating the user, so we are getting the ID
        //the id is the value of the instance of the database user
        userIDColumn: owner.id,
        textColumn: text,
        isSyncedColumn:1,
      });
      //so the main id of this note will be the noteID
      final notes = DatabaseNotes(
        id: noteId, 
        userId: owner.id, 
        text: text, 
        isSyncedWithCloud: true
      );
    return notes; 
  }

  //delete a note
  Future<void> deleteNotes({required int id}) async {
    //get the cureent database
    final db = _getDatabaseOrThrow();
    //just delete
    final deletedNote = await db.delete(
      noteTable,
      where: ' id = ? ',
      //get the list of ids thaat need deleting
      whereArgs: [id]
    );
    //check if it was deleted successfully
    if (deletedNote == 0) {
      throw CouldNotDeleteNotes();
    }
  }

  //ability to delete all notes
  Future<int> deleteAllNotes() async {
    //get the database
    final db = _getDatabaseOrThrow();
    //to achieve deleteing all notes, we just simply delete the table
    final notesDeleteCount = await db.delete(noteTable);
    return notesDeleteCount;
  }

  //fetch a specific notes
  //so if the user click on a note, we want to get the id of the notes, and get the details
  Future<DatabaseNotes> getNotes({required int id}) async{
    //get database
    final dba = _getDatabaseOrThrow();
    //query the database to get the notes with that id
    final notes = await dba.query(
      noteTable,
      //we only want one result
      limit: 1,
      where: ' id = ? ',
      //where the idis from a map of id, that will be given from the frontend
      whereArgs: [id]
    );
    //check to see if the note is empty or doesnt exist
    if (notes.isEmpty) {
      throw CouldNotFindNote();
    } else {
      //return the first item, which it is usually
      return DatabaseNotes.fromRow(notes.first);
    }
  }

  //get all notes in the recycle view
  //we are return a list of databasenotes
  Future<Iterable<DatabaseNotes>> getAllNotes() async{
    final db = _getDatabaseOrThrow();
    //query note table to get all the notes
    final allNotes = await db.query(noteTable);
    return allNotes.map((noteRow) => DatabaseNotes.fromRow(noteRow));
  }

  //update the existing note
  Future<DatabaseNotes> updateNote({
    required DatabaseNotes note, required String text
  }) async {
    final db = _getDatabaseOrThrow();
    //get the id of the note
    await getNotes(id: note.id);
    //query to update the note
    final updateCount = await db.update(
      noteTable, {
        textColumn: text,
        isSyncedColumn: 0
      }
    );
    //check if the notes was updated
    if (updateCount == 0) {
      throw CouldNotUpdateNote();
    } else {
      //so if the update was successful. get the note
      return await getNotes(id: note.id);
    }
  }
}


//this is more like defining the schema of the tables
//to create the user class or table 
@immutable
class DatabaseUser {
  //creating the user table
  final int id;
  final String email;

//constructor
  DatabaseUser({ 
    required this.id, 
    required this.email,
  });

  //we need to create an instances of hte databse and its column
  //and assign to the vlaues in the consructor
  DatabaseUser.fromRow(Map<String, Object?> map) 
  : id = map[idColumn] as int, 
  email = map[emailColumn] as String;

  //create a toString Function
  @override
  String toString() => 'Person, ID = $id, email = $email';

  //implement equality
  //covariant helps us to compare between twon users
  @override 
   bool operator == (covariant DatabaseUser other) => id == other.id;
   
     @override
     //replace super.hascode witht id.hashcode
     //this makes the id become the primary key of the class
     int get hashCode => id.hashCode;
}


//database note table 
class DatabaseNotes {
  //list of entities
  final int id;
  final int userId;
  final String text;
  //wont really be used
  final bool isSyncedWithCloud;

//their constructors
  DatabaseNotes({
    required this.id, 
    required this.userId, 
    required this.text, 
    required this.isSyncedWithCloud,
  });

//call the map of the entities
  DatabaseNotes.fromRow(Map<String, Object?> map)
  //start assigning the values to the varibles to create the db
  : id = map[idColumn] as int,
    userId = map[userIDColumn] as int,
    text = map[textColumn] as String,
    //since we don't have thisas bool in the db, we have to read it as an interger here
    //so to represent as a bool, we have to ask the the program that is its one, then its true else its false
    //so it will save as true or false
    isSyncedWithCloud = (map[isSyncedColumn] as int ) == 1 ? true : false;

  @override
  //but we won't print the text, because of space
  String toString() => 'Note ID = $id, userID = $userId, isSyncedWithCloud = $isSyncedWithCloud';
  
  //the equality of id, because it is very important no two user has the same id
  @override 
   bool operator == (covariant DatabaseUser other) => id == other.id;
   
     @override
     int get hashCode => super.hashCode;
   
}