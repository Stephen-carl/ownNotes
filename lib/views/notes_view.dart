// ignore_for_file: use_build_context_synchronously

//the main UI for those who are logged in
import 'package:flutter/material.dart';
import 'package:ownnotes/constants/routes.dart';
import 'package:ownnotes/enums/menu_actions.dart';
import 'package:ownnotes/main.dart';
import 'package:ownnotes/service/auth/auth_service.dart';

class Notesview extends StatefulWidget {
  const Notesview({super.key});

  @override
  State<Notesview> createState() => _NoteviewState();
}

class _NoteviewState extends State<Notesview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
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
      body: const Column(
        children: [

        ],
      )
    );
  }
}