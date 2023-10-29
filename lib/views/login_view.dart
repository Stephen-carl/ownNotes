import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

import 'package:ownnotes/constants/routes.dart'; 

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
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      notesRoute, 
                      (_) => false,
                    );
                  } 
                  //to read the exact error and work on it
                  //it has a email and password exception
                  on FirebaseAuthException catch (e) {
                    if (e.code == 'invalid-login-credentials') {
                      devtools.log('invalid-login-credentials');
                    } else {
                      devtools.log(e.code);
                    }
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
              TextButton(onPressed: () {
                //to go to the register page
                Navigator.of(context).pushNamedAndRemoveUntil(
                  verifyRoute, 
                  (route) => false);
              }, 
              child: const Text ('Verify Email'),
              ),
            ],
          ),
    );
  }
}