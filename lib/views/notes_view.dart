// ignore_for_file: use_build_context_synchronously

//the main UI for those who are logged in
import 'package:flutter/material.dart';
import 'package:ownnotes/constants/routes.dart';
import 'package:ownnotes/enums/menu_actions.dart';
import 'package:ownnotes/main.dart';
import 'package:ownnotes/service/auth/auth_service.dart';
import 'package:ownnotes/service/crud/notes_service.dart';

class Notesview extends StatefulWidget {
  const Notesview({super.key});

  @override
  State<Notesview> createState() => _NoteviewState();
}

class _NoteviewState extends State<Notesview> {
  //get the noteservice
  late final NotesService _notesService;
  //expose the user email from firebase 
  String get userEmail => AuthService.firebase().currentUser!.email!;

  //open the Database
  @override
  void initState(){
    //initialize note service//s
    _notesService = NotesService();
    super.initState();
  }
  //close DB
  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(newNoteRoute);
            }, 
            icon: const Icon(Icons.add),
          ),
          //here we declare the enum in the popupMenuButton
          PopupMenuButton<MenuAction>(
            onSelected: (value) async{
            //switch between cases of the popup item
              switch (value) {
                case MenuAction.logout:
                  //so here , it should didplay the dialog function  which has been defined
                  //so we passed in the context of the notesview
                final shouldlogout = await showLogOutDialog(context);
                if (shouldlogout) {
                await AuthService.firebase().logout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute, 
                (_) => false);
            }
            }
            
          }, 
          itemBuilder: (context) {
            return const  [
              PopupMenuItem(
                //then call the menu item
                value: MenuAction.logout,
              child: Text('Log out')
              ),
            ];
          })
        ],
      ),
      body: FutureBuilder(
        future: _notesService.getorcreateUser(email: userEmail), 
        builder: (context, snapshot) {
          //grab all notes from stream controller to be displayed
          switch (snapshot.connectionState) {
            
            case ConnectionState.done:
            //upon the connection successful, we will build widget with the data
              return StreamBuilder(
                //call the function that grabs all the notes
                stream: _notesService.allNotes, 
                builder: (context, snapshot){
                  switch (snapshot.connectionState) {
                    //waiting for a data that has not been inputed
                    case ConnectionState.waiting:
                    
                    //so once there is a data tobe returned, then the connection state will will change
                    case ConnectionState.active:
                     
                    default:
                    return const CircularProgressIndicator();
                  }
                });
            default:
            //just return an indicator while doing the process
            return const CircularProgressIndicator();
          }
        },
      )
    );
  }
}