// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ownnotes/constants/routes.dart';
import 'package:ownnotes/utilities/show_error_dialog.dart'; 

//Registeration App
class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

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
      appBar: AppBar(
        title: const Center(child: Text('Register')),
      ),
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
                  try {
                    //instantiate the firebase auth to get the function to create a user
                  //create instants of firebaseAuth
                  //using await makes the process start
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email, 
                    password: password
                    );
                    //here instead of makinig the user click the button in the verifyemail
                    //we will send the mail from here, by first getting the currentuser
                    final currentUser = FirebaseAuth.instance.currentUser;
                    await currentUser?.sendEmailVerification();
                    //take user to verify his or her mail
                    //but in this case, our verification is not functioning for now, so we will push the user to the notesview
                    //if we are to navigate to verify email, we need to use pushNamed() function only
                    Navigator.of(context).pushNamed(verifyRoute);
                  } on FirebaseAuthException catch (e) {  
                    if (e.code == 'weak-password') {
                      //call the error dialog function
                      await showErrorDialog(
                        //context is gotten from the builContent of the view
                        context, 
                        'Minimum of 6 characters',
                      );
                    } else if (e.code == 'email-already-in-use') {
                      await showErrorDialog(
                        //context is gotten from the builContent of the view
                        context, 
                        'Email is already in use',
                      );                      
                    } else if (e.code == 'invalid-email') {
                      await showErrorDialog(
                        //context is gotten from the builContent of the view
                        context, 
                        'Invalid email entered',
                      ); 
                    } else {
                      await showErrorDialog(
                        //context is gotten from the builContent of the view
                        context, 
                        'Error: ${e.code}',
                      );
                    }
                  }   
                  //for other exceptions
                  //we can attach other catch statement
                  catch (e){
                    await showErrorDialog(
                        //context is gotten from the builContent of the view
                        context, 
                        e.toString(),
                      );
                  }
                              
                }, 
                child: const Text(
                  'Register',
                  )
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute, 
                      (route) => false);
                }, 
                child: const Text('Already Registered? Sign In')
              ),
            ],
          ),
    );
  }
}


