import 'package:flutter/material.dart';
import 'package:ownnotes/service/auth/auth_service.dart';
import 'package:ownnotes/service/crud/notes_service.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  //to keep hold of the notes that will be created 
  DatabaseNotes? _note;
  //reference to NoteService
  late final NotesService _notesService;
  
  //the text controller
  late final TextEditingController _textController;

  @override
  void initState() {
    //instance of note service and text controller
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  //to save or update automatically
  void _textControllerListener() async{
    //get the note
    final note = _note;
    //check if null and return nothiing
    if (note == null) {
      return;
    }
    //get the text and update
    final text = _textController.text;
    await _notesService.updateNote(
      note: note, 
      text: text
    );
  }

  void _setUpControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  //so we have to get the notes from the database, and check if we have created the notes before
  //so if we have, no need to recreate it, else create a new note
  Future<DatabaseNotes> createNewNote() async{
    final existinNotes = _note;
    if (existinNotes != null) {
      //so there is something it
      return existinNotes;
    }
    //grab the email from the user that was created in the databse
    //this will make the app crash if by any means, someone ends up here with signing in
    final currentUser = AuthService.firebase().currentUser;
    final email = currentUser!.email!;
    //get the owner
    final owner = await _notesService.getUser(email: email);
    //create a note with that owner email, so it will be pass into the function to tie user to the note
   return await _notesService.createNotes(owner: owner);
  }

  //delete note if it is empty upon disposal
  void _deleteNoteIfTextIsEmpty() {
    //get the note
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      //delete
      _notesService.deleteNotes(id: note.id);
    }
  }

  //save the note if it not empty, since we will not have a save button, it is saved automatically upon disposal
  void _saveNoteIfTextNotEmpty() async{
    //get the table and the text
    final note = _note;
    final text = _textController.text;
    //check if the table is not null and the text is not empty
    if (note != null && text.isNotEmpty) {
      //call the function to automatically update
      await _notesService.updateNote(
        note: note, 
        text: text
      );
    }
  }


  @override
  void dispose() {
    //call the functions
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
      ),
      //our future builder is going to create a note in the database and return a builder
      body: FutureBuilder(
        //the future is to create a new note
        future: createNewNote(), 
        builder: (context, snapshot) {
          //switch if the connection to the future is succesful
          switch (snapshot.connectionState) {
            
              case ConnectionState.done:
              //to get notes from snapshot
              //// _note = snapshot.data as DatabaseNotes;
              //start listening to user changes on the UI
              _setUpControllerListener();
              //for the main Ui
              return TextField(
                //connect to the controller
                controller: _textController,
                //allow user to enter multiple line text
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Start Typing...'
                ),
              );
              
            default:
            return const CircularProgressIndicator();
          }
        },),
    );
  }
}