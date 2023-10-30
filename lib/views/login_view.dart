// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'dart:developer' as devtools show log;

import 'package:ownnotes/constants/routes.dart';
import 'package:ownnotes/utilities/show_error_dialog.dart'; 

//Login View
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  //to create the text controllers
  late final TextEditingController _email;
  late final TextEditingController _password;

//intitstate is called when the Homepage is called
  @override
  void initState() {
    //we need to link the controller tot he textfield
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  //then you have to dispose them when the homepage is closed
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Login')),),
      body: Column(
            children: [
              //to have something like editText
              TextField(
                controller: _email,
                autocorrect: true,
                enableSuggestions: true,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter email'
                ),
                ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'Enter password'
                ),
                ),
              TextButton(
                //add a function to the onPressed.
                onPressed: () async{
                  //get the text from the editText and put in a string
                  var email = _email.text;
                  var password = _password.text;
                  //to handle exception and prevent crash
                  try {
                    //instantiate the firebase auth to get the function to create a user
                  //create instants of firebaseAuth
                  //using await makes the process start
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email, 
                    password: password
                    );
                    final useer = FirebaseAuth.instance.currentUser;
                    //if user email verification is false
                    if (useer?.emailVerified??false) {
                      //users email is verified, push to NotesView
                      //once confirmed, take the user to the notesView
                      Navigator.of(context).pushNamedAndRemoveUntil(
                      notesRoute, 
                      (route) => false,
                    );
                    } else {
                      //user's email is not verified, push to verify mail
                      Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyRoute, 
                      (route) => false,
                    );
                    }
                                      
                  } 
                  //to read the exact error and work on it
                  //it has a email and password exception
                  on FirebaseAuthException catch (e) {
                    if (e.code == 'invalid-login-credentials') {
                      //call the error dialog function
                      await showErrorDialog(
                        //context is gotten from the builContent of the view
                        context, 
                        'invalid-login-credentials',
                      );
                    } else if(e.code == 'invalid-email'){
                      await showErrorDialog(
                        //context is gotten from the builContent of the view
                        context, 
                        'invalid-email',
                      );
                    } else {
                      //so incase there are other errors i did not notice
                      await showErrorDialog(
                        //context is gotten from the builContent of the view
                        context, 
                        'Error: ${e.code}',
                      );
                    }
                  }
                  //to handle other excpetion
                  catch(e) {
                    await showErrorDialog(
                        //context is gotten from the builContent of the view
                        context, 
                        e.toString(),
                      );
                  }              
                }, 
                child: const Text(
                  'Login',
                  )
              ),
              TextButton(onPressed: () {
                //to go to the register page
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute, 
                  (route) => false);
              }, 
              child: const Text ('Register here'),
              ),
            ],
          ),
    );
  }
}