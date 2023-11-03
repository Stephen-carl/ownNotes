// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ownnotes/constants/routes.dart';
import 'package:ownnotes/service/auth/auth_service.dart';
import 'package:ownnotes/views/login_view.dart';
import 'package:ownnotes/views/notes/new_note_view.dart';
import 'package:ownnotes/views/notes_view.dart';
import 'views/register_view.dart';
import 'package:ownnotes/views/verify_email_view.dart';

//this is the main function in flutter app
void main() {
  //this is to bind firebase with the application before any major is done
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      title: 'Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Homepage(),
      routes: {
        loginRoute: (context) => const  LoginView(),
        registerRoute: (context) => const RegisterView(),
        verifyRoute:(context) => const VerifyEmailView(),
        notesRoute:(context) => const Notesview(),
        newNoteRoute:(context) => const NewNoteView(),
      },
    ),
  );
}

//the homepage will help to iniitialize firebase 
//to get rid of the app always initializing during the routes
class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().iniitialize(),
        //snapshot is a way of geting the result of your future 
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
            //get the current user
           final user = AuthService.firebase().currentUser;
           //now what i want to do is to check if the current user is verified
           //else let them verify
           if (user != null) {
            if (user.isEmailVerified) {
              return const Notesview();
            }
          //   } //else if there is no user loggedn
          else {
              //why it is verify is bcus the user must have registered but not verified
            return const VerifyEmailView();
            } 
           } else {
            //if the user is null, go to login
            return const LoginView();
           }

           //default signifies anything else that has not been handled
        default:
        //this is to make things look better display a circular 
        return const CircularProgressIndicator();
          }
        },
      );
  }
}

//the list of nemu items


//this function is primarily to show the alert dialog
//create a logout function called showLogOutDialog which must be built in a context where it will be displayed
Future<bool> showLogOutDialog (BuildContext context) {
  return showDialog<bool>(
    context: context, 
    builder: (context) {
      //return the alert dialog that will be displayed
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Do you really want to logout?'),
        actions: [
          //here we introuce the two buttons that are to be displayed
          TextButton(
            onPressed: () {
              //so when it is cancelled pop the value of false, so it wont do anything
              Navigator.of(context).pop(false);
          }, 
          child: Text('Cancel')
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
          }, 
          child: Text('Logout')
          ),
        ],
      );
    }
    //so if the user dismiss the dialog, it shouldnt have a value
  ).then((value) => value??false);
}